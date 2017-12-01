//
//  BannerListLayout.swift
//  TableDemo
//
//  Created by Huang Peng on 01/12/2017.
//  Copyright © 2017 Huang Peng. All rights reserved.
//

import UIKit

class BannerListLayout: UICollectionViewFlowLayout {
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }
        
        let horizontalOffset = proposedContentOffset.x + 5
        
        let itemSize = collectionView.bounds.size
        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: itemSize.width, height: itemSize.height)
        
        guard let array = layoutAttributesForElements(in: targetRect) else {
            return proposedContentOffset
        }
        
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        for layoutAttributes in array {
            let itemOffset = layoutAttributes.frame.origin.x
            if (abs(itemOffset - horizontalOffset) < abs(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
