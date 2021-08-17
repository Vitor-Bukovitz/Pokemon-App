//
//  ListViewController.swift
//  PokemonApp
//

import UIKit

protocol ListViewProtocol {
    /// Variables
    var presenter: ListPresenterProtocol? { get set }
    
    /// Called from the presenter to update the view with the pokemon list received from the interactor
    func update(with pokemonList: [Pokemon])
}

class ListViewController: UIViewController, ListViewProtocol {
    
    private let backgroundView = UIView()
    
    lazy private var collectionView: UICollectionView = {
        let collectionViewLayout = UIHelper.createTwoColumnFlowLayout(in: view)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        collectionView.backgroundView = backgroundView
        collectionView.register(ListCardCell.self, forCellWithReuseIdentifier: ListCardCell.reuseID)
        collectionView.isHidden = true
        return collectionView
    }()
    
    private let cornerImageView: UIImageView = {
        let cornerImageView = UIImageView()
        cornerImageView.translatesAutoresizingMaskIntoConstraints = false
        cornerImageView.image = .pokeBallImage
        return cornerImageView
    }()
    
    private let loadingImageView: UIImageView = {
       let loadingImageView = UIImageView()
        loadingImageView.translatesAutoresizingMaskIntoConstraints = false
        loadingImageView.image = .pokeBallImage
        
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.byValue = 2 * CGFloat.pi
        rotation.duration = 4
        rotation.repeatCount = Float.greatestFiniteMagnitude

        loadingImageView.layer.add(rotation, forKey: "myAnimation")
        return loadingImageView
    }()
    
    private let loadingLabel: UILabel = {
       let loadingLabel = UILabel()
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.text = "Loading"
        loadingLabel.textColor = .primaryColor
        return loadingLabel
    }()
    
    private var pokemonList = [Pokemon]()
    
    var presenter: ListPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.fetchPokemonList()
    }
    
    func update(with pokemonList: [Pokemon]) {
        title = "Pokedex"
        self.pokemonList = pokemonList
        collectionView.reloadData()
        collectionView.isHidden = false
        loadingLabel.isHidden = true
        loadingImageView.isHidden = true
    }
}

// MARK: Layout
extension ListViewController {
    
    private func setupView() {
        // UIViewController Setup
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Add Views
        view.addSubview(collectionView)
        view.addSubview(loadingImageView)
        view.addSubview(loadingLabel)
        backgroundView.addSubview(cornerImageView)
        
        // Constraints
        NSLayoutConstraint.activate([
            cornerImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -42),
            cornerImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: 52),
            cornerImageView.widthAnchor.constraint(equalToConstant: 214),
            cornerImageView.heightAnchor.constraint(equalToConstant: 214),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.widthAnchor.constraint(equalToConstant: 76),
            loadingImageView.heightAnchor.constraint(equalToConstant: 76),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingImageView.bottomAnchor, constant: 4),
            loadingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}

// MARK: - CollectionView Delegates
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCardCell.reuseID, for: indexPath) as? ListCardCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}
