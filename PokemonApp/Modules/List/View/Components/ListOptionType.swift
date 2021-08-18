//
//  ListOptionType.swift
//  PokemonApp
//
//  Created by PremierSoft on 17/08/21.
//

import UIKit

class ListOptionType: UIView {
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.textColor = .Text.secondaryColor
        return textLabel
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    func setup(for type: PokemonCategoryConstants) {
        textLabel.text = type.rawValue
    }
}

extension ListOptionType {
    
    private func setupView() {
        // View Setup
        backgroundColor = .Theme.backgroundColor.withAlphaComponent(0.3)
        
        // Add Views
        addSubview(textLabel)
        
        // Constraints
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
        ])
    }
}
