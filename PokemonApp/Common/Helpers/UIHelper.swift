//
//  UIHelper.swift
//  PokemonApp
//

import UIKit

struct UIHelper {
    
    static func createTwoColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let avaiableWidth = width - (padding * 2) - (padding)
        let itemWidth = avaiableWidth / 2
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.7)

        return flowLayout
    }
}
