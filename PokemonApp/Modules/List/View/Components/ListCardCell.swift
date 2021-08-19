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
        titleLabel.textColor = .Text.secondaryColor
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return titleLabel
    }()
    
    private let numLabel: UILabel = {
        let numLabel = UILabel()
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        numLabel.textColor = .Text.primaryColor.withAlphaComponent(0.1)
        numLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return numLabel
    }()
    
    private let cornerImageView: UIImageView = {
        let cornerImageView = UIImageView()
        cornerImageView.translatesAutoresizingMaskIntoConstraints = false
        cornerImageView.image = .pokeBallImage?.withRenderingMode(.alwaysTemplate)
        cornerImageView.tintColor = .Theme.primaryColor.withAlphaComponent(0.3)
        return cornerImageView
    }()
    
    private let pokemonImageView: UIImageView = {
        let pokemonImageView = UIImageView()
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.contentMode = .scaleAspectFit
        return pokemonImageView
    }()
    
    private let typeStackView: UIStackView = {
        let typeStackView = UIStackView()
        typeStackView.translatesAutoresizingMaskIntoConstraints = false
        typeStackView.axis = .vertical
        typeStackView.spacing = 6
        return typeStackView
    }()
    
    var downloadTask: URLSessionDataTask?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    override func prepareForReuse() {
        downloadTask?.cancel()
        pokemonImageView.image = nil
    }
    
    func setup(for pokemon: Pokemon) {
        contentView.backgroundColor = pokemon.type.first?.getColor()
        titleLabel.text = pokemon.name
        numLabel.text = "#\(pokemon.num)"
        downloadTask = pokemonImageView.setRemoteImage(with: pokemon.img)
        addTypesToStackView(pokemon.type)
    }
}

extension ListCardCell {
    
    private func setupView() {
        // ContentView Setup
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        // Add Views
        contentView.addSubview(cornerImageView)
        contentView.addSubview(numLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(typeStackView)
        contentView.addSubview(pokemonImageView)
        
        // Constraints
        NSLayoutConstraint.activate([
            cornerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 14),
            cornerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 6),
            cornerImageView.heightAnchor.constraint(equalToConstant: 94),
            cornerImageView.widthAnchor.constraint(equalToConstant: 94),
            
            numLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            numLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            numLabel.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: numLabel.bottomAnchor, constant: -6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: numLabel.trailingAnchor, constant: 6),
            
            typeStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            typeStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            typeStackView.trailingAnchor.constraint(equalTo: pokemonImageView.leadingAnchor),
            typeStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            pokemonImageView.topAnchor.constraint(equalTo: numLabel.bottomAnchor, constant: 12),
            pokemonImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
        ])
    }
    
    private func addTypesToStackView(_ types: [PokemonCategoryConstants]) {
        typeStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for type in types {
            let view = UIView()
            let listOptionType = ListOptionType()
            view.addSubview(listOptionType)
            listOptionType.setup(for: type)
            listOptionType.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                listOptionType.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                listOptionType.topAnchor.constraint(equalTo: view.topAnchor),
                listOptionType.widthAnchor.constraint(greaterThanOrEqualToConstant: 1),
                listOptionType.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
                listOptionType.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
            typeStackView.addArrangedSubview(view)
        }
    }
}
