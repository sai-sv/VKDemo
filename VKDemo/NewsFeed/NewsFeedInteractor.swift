//
//  NewsFeedInteractor.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    private let dataFetcher: VKDataFetcher = VKNetworkDataFetcher()
    private var response: NewsFeedResponse?
    private var revealedPostIds = Array<Int>()
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        switch request {
        case .getNewsFeed:
            dataFetcher.getNewsFeed() { [weak self] response in
                
                self?.response = response
                self?.presentData()
            }
            
        case.revealPostText(let postId):
            revealedPostIds.append(postId)
            presentData()
            break
        }
    }
    
    private func presentData() {
        guard let response = response else { return }
        presenter?.presentData(response: .newsFeedResponse(response: response, revealedPostIds: revealedPostIds))
    }
    
}
