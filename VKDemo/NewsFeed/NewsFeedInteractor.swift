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
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        switch request {
        case .getNewsFeed:
            dataFetcher.getNewsFeed() { [weak self] response in
                guard let response = response else { return }
                self?.presenter?.presentData(response: .newsFeedResponse(response: response))
            }
        }
    }
    
}
