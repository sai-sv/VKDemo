//
//  NewsFeedViewController.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

protocol NewsFeedDisplayLogic: class {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {
    
    @IBOutlet weak var tableView: UITableView!
    private var titleView = TitleView()
    private var topRefreshIndicator: UIRefreshControl = {
        var control = UIRefreshControl()
        control.addTarget(self, action: #selector(topRefreshAction), for: .valueChanged)
        return control
    }()
    private var model = FeedViewModel(cells: [])
    
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    
    // MARK: Object lifecycle
    
    /*override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
     super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
     setup()
     }
     
     required init?(coder aDecoder: NSCoder) {
     super.init(coder: aDecoder)
     setup()
     }*/
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsFeedInteractor()
        let presenter             = NewsFeedPresenter()
        let router                = NewsFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTopBars()
        setupTableView()
        
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        interactor?.makeRequest(request: .getNewsFeed)
        interactor?.makeRequest(request: .getUsers)
    }
    
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        
        switch viewModel {
        case .displayNewsFeed(let viewModel):
            self.model = viewModel
            self.tableView.reloadData()
            self.topRefreshIndicator.endRefreshing()
        case .displayUserInfo(let viewModel):
            titleView.set(viewModel: viewModel)
        }
    }
    
    private func setupTopBars() {
        
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.titleView = titleView
    }
    
    private func setupTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "NewsFeedCell", bundle: nil), forCellReuseIdentifier: NewsFeedCell.id)
        tableView.register(NewsFeedCodeCell.self, forCellReuseIdentifier: NewsFeedCodeCell.id)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.addSubview(topRefreshIndicator)
    }
    
    @objc private func topRefreshAction() {
        interactor?.makeRequest(request: .getNewsFeed)
    }
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.id, for: indexPath) as! NewsFeedCell
        //        let cellViewModel = model.cells[indexPath.row]
        //        cell.configure(with: cellViewModel)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCodeCell.id, for: indexPath) as! NewsFeedCodeCell
        let cellViewModel = model.cells[indexPath.row]
        cell.configure(with: cellViewModel)
        
        // handle show more text button touch action
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = model.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = model.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
}

extension NewsFeedViewController: NewsFeedCodeCellDelegate {
    func revealPost(for cell: NewsFeedCodeCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = model.cells[indexPath.row]
        let postId = cellViewModel.postId
        
        //        print("post id: \(postId)")
        interactor?.makeRequest(request: .revealPostText(postId: postId))
    }
}
