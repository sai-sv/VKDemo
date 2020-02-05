//
//  NewsFeedPresenter.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    weak var viewController: NewsFeedDisplayLogic?
    private let cellLayoutCalculator: NewsFeedCellLayoutCalculatorProtocol = NewsFeedCellLayoutCalculator()
       
    private let dateFormatter: DateFormatter = {
       let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        switch response {
        case .newsFeedResponse(let response):
            let cells = response.items.map { (item) in
                    
                cellViewModel(item, profiles: response.profiles, groups: response.groups)
            }
            let viewModel = FeedViewModel(cells: cells)
            
            viewController?.displayData(viewModel: .displayNewsFeed(viewModel: viewModel))
            break
        }
    }
    
    private func profile(_ sourceId: Int, profiles: [UserProfile], groups: [GroupProfile]) -> ProfileRepresentable? {
        let profiles: [ProfileRepresentable] = sourceId < 0 ? groups : profiles
        let targetSourceId = sourceId < 0 ? -sourceId : sourceId
        return profiles.first { $0.id == targetSourceId }
    }
    
    private func photoViewModel(_ item: NewsFeedItem) -> FeedViewModel.CellPhotoAttachmentViewModel? {
        let photos = item.attachments?.compactMap({ (attachment) in
            attachment.photo
        })
        
        if let photo = photos?.first {
            return FeedViewModel.CellPhotoAttachmentViewModel(photoURL: photo.url, width: photo.width, height: photo.height)
        }
        return nil
    }
    
    private func cellViewModel(_ item: NewsFeedItem, profiles: [UserProfile], groups: [GroupProfile]) -> FeedViewModel.CellViewModel {
        
        let profile = self.profile(item.sourceId, profiles: profiles, groups: groups)
        
        let date = Date(timeIntervalSince1970: item.date)
        let dateTitle = dateFormatter.string(from: date)
        
        let photoAttachmentViewModel = photoViewModel(item)
        
        let sizes = cellLayoutCalculator.sizes(postText: item.text, postPhotoAttachment: photoAttachmentViewModel)
        
        return FeedViewModel.CellViewModel(icon: profile?.photo ?? "",
                                                   name: profile?.name ?? "",
                                                   date: dateTitle,
                                                   text: item.text,
                                                   likes: String(item.likes?.count ?? 0),
                                                   comments: String(item.comments?.count ?? 0),
                                                   reposts: String(item.reposts?.count ?? 0),
                                                   views: String(item.views?.count ?? 0),
                                                   photoAttachment: photoAttachmentViewModel,
                                                   sizes: sizes)
    }
}
