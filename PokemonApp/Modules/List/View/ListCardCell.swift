//
//  ListCardCell.swift
//  PokemonApp
//

import UIKit

class ListCardCell: UICollectionViewCell {
    
    static let reuseID = "ListCardCell"
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return titleLabel
    }()
    
    private let numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        numLabel.textColor = .black.withAlphaComponent(0.1)
        numLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return numLabel
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setup(for pokemon: Pokemon) {
        contentView.backgroundColor = pokemon.type.first?.getColor()
        titleLabel.text = pokemon.name
        numLabel.text = "#\(pokemon.num)"
    }
}

extension ListCardCell {
    
    private func setupView() {
        // ContentView Setup
        contentView.layer.cornerRadius = 12
        
        // Add Views
        contentView.addSubview(titleLabel)
        contentView.addSubview(numLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 21),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            
            numLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            numLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14)
            
        ])
    }
}
