//
//  ListCardCell.swift
//  PokemonApp
//

import UIKit

class ListCardCell: UICollectionViewCell {
    
    static let reuseID = "ListCardCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
}

extension ListCardCell {
    
    private func setupView() {
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .systemRed
    }
}
