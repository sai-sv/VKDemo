//
//  VKNetworkDataFetcher.swift
//  VKDemo
//
//  Created by Admin on 27.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation

protocol VKDataFetcher {
    func getNewsFeed(response: @escaping (NewsFeedResponse?) -> Void)
}

struct VKURLConstants {
    static let scheme = "https"
    static let host = "api.vk.com"
    static let apiVersion = "5.103"
    
    static let getNewsfeedMethod = "/method/newsfeed.get"
}

class VKNetworkDataFetcher: NetworkDataFetcher, VKDataFetcher {
    
    private let accessToken: String?
    private var accessTokenItem: URLQueryItem {
        return URLQueryItem(name: "access_token", value: accessToken)
    }
    private var versionItem: URLQueryItem {
        return URLQueryItem(name: "v", value: VKURLConstants.apiVersion)
    }
    
    init() {
        accessToken = AppDelegate.shared().authService?.accessToken
        super.init()
    }
    
    // MARK: - VKDataFetcher
    func getNewsFeed(response: @escaping (NewsFeedResponse?) -> Void) {
     
        var components = URLComponents()
        components.scheme = VKURLConstants.scheme
        components.host = VKURLConstants.host
        components.path = VKURLConstants.getNewsfeedMethod
        let filters = URLQueryItem(name: "filters", value: "post, photo")
        components.queryItems = [ filters, accessTokenItem, versionItem]
        
        let request = URLRequest(url: components.url!)
        
        self.fetchData(request: request) { (result: Result<NewsFeedWrapper, Error>) in
            
            switch result {
            case .success(let data):
                response(data.response)
                //print(data.response)
            case .failure(let error):
                print(error)
            }
        }
    }
}
