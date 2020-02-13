//
//  NewsFeedModels.swift
//  VKDemo
//
//  Created by Admin on 22.12.2019.
//  Copyright (c) 2019 sergei. All rights reserved.
//

import UIKit

enum NewsFeed {
    
    enum Model {
        struct Request {
            enum RequestType {
                case getNewsFeed
                case revealPostText(postId: Int)
            }
        }
        struct Response {
            enum ResponseType {
                case newsFeedResponse(response: NewsFeedResponse, revealedPostIds: [Int])
            }
        }
        struct ViewModel {
            enum ViewModelData {
                case displayNewsFeed(viewModel: FeedViewModel)
            }
        }
    }
}

struct FeedViewModel {
    
    struct CellViewModel: NewsFeedCellViewModel {
        var postId: Int
        var icon: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var reposts: String?
        var views: String?
        var photoAttachment: NewsFeedCellPhotoAttachmentViewModel?
        var sizes: NewsFeedCellSizes
    }
    
    struct CellPhotoAttachmentViewModel: NewsFeedCellPhotoAttachmentViewModel {
        var photoURL: String
        var width: Int
        var height: Int
    }
    
    var cells: [CellViewModel]
}
