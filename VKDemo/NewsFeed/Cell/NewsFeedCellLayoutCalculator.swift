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
    
    func sizes(text: String?, photoAttachment: NewsFeedCellPhotoAttachmentViewModel?) -> NewsFeedCellSizes
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
    
    func sizes(text: String?, photoAttachment: NewsFeedCellPhotoAttachmentViewModel?) -> NewsFeedCellSizes {
        
        let cardViewWidth = screenWidth - Constants.cardViewInsets.left - Constants.cardViewInsets.right
        
        // MARK: - Post Text Size
        var textFrame = CGRect(origin: CGPoint(x: Constants.textInsets.left, y: Constants.textInsets.top), size: CGSize.zero)
        if let text = text, !text.isEmpty {
            let width = cardViewWidth - Constants.textInsets.left - Constants.textInsets.right
            let height = text.height(width: width, font: Constants.textFont)
            textFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: - Photo Attachment Size
        
        // TODO:
        return CellSizes(textFrame: textFrame,
                         photoAttachmentFrame: CGRect.zero,
                         bottomViewFrame: CGRect.zero,
                         totalHeight: 300)
    }
    
}
