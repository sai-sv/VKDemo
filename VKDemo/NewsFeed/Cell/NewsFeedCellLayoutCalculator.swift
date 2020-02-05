//
//  NewsFeedCellLayoutCalculator.swift
//  VKDemo
//
//  Created by Admin on 04.02.2020.
//  Copyright © 2020 sergei. All rights reserved.
//

import Foundation
import UIKit

protocol NewsFeedCellLayoutCalculatorProtocol {
    
    func sizes(postText: String?, postPhotoAttachment: FeedViewModel.CellPhotoAttachmentViewModel?) -> NewsFeedCellSizes
}

struct CellSizes: NewsFeedCellSizes {
    var textFrame: CGRect
    var photoAttachmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

struct Constants {
    static let cardViewInsets = UIEdgeInsets(top: 0, left: 8, bottom: 12, right: 8)
    static let topViewHeight: CGFloat = 36
    static let textInsets = UIEdgeInsets(top: 8 + topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let textFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHeight: CGFloat = 44
}

final class NewsFeedCellLayoutCalculator: NewsFeedCellLayoutCalculatorProtocol {
    
    private var screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, postPhotoAttachment: FeedViewModel.CellPhotoAttachmentViewModel?) -> NewsFeedCellSizes {
        
        let cardViewWidth = screenWidth - Constants.cardViewInsets.left - Constants.cardViewInsets.right
        
        // MARK: - post text frame
        var postTextFrame = CGRect(origin: CGPoint(x: Constants.textInsets.left, y: Constants.textInsets.top), size: CGSize.zero)
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.textInsets.left - Constants.textInsets.right
            let height = text.height(width: width, font: Constants.textFont)
            postTextFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: - post photo attachment frame
        let photoAttacmentTop = postTextFrame.size == CGSize.zero ? Constants.textInsets.top : postTextFrame.maxY + Constants.textInsets.bottom
        var postPhotoAttachmentFrame = CGRect(origin: CGPoint(x: 0, y: photoAttacmentTop), size: CGSize.zero)
        if let photoAttachment = postPhotoAttachment {
            
            let ratio = CGFloat(CGFloat(photoAttachment.height) / CGFloat(photoAttachment.width))
            let height = CGFloat(cardViewWidth) * ratio
            postPhotoAttachmentFrame.size = CGSize(width: cardViewWidth, height: height)
        }
        
        // MARK: - bottom view frame
        let bottomViewTop = max(postTextFrame.maxY, postPhotoAttachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        // MARK: - total height
        let totalHeight: CGFloat =  bottomViewFrame.maxY + Constants.cardViewInsets.bottom
        
        return CellSizes(textFrame: postTextFrame,
                         photoAttachmentFrame: postPhotoAttachmentFrame,
                         bottomViewFrame: bottomViewFrame,
                         totalHeight: totalHeight)
    }
}
