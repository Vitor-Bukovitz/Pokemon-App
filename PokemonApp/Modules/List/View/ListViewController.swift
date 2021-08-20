//
//  ListViewController.swift
//  PokemonApp
//

import UIKit

protocol ListViewProtocol: AnyObject {
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
        collectionView.alpha = 0
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

        loadingImageView.layer.add(rotation, forKey: "rotationAnimation")
        return loadingImageView
    }()
    
    private var pokemonList = [Pokemon]()
    private var loadingImageViewCenterYConstraint: NSLayoutConstraint?
    
    var presenter: ListPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.fetchPokemonList()
    }
    
    func update(with pokemonList: [Pokemon]) {
        self.pokemonList = pokemonList
        collectionView.reloadData()
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.35) {
            self.collectionView.alpha = 1
            self.loadingImageViewCenterYConstraint?.isActive = false
            self.loadingImageView.topAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
            self.navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.Text.primaryColor]
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.loadingImageView.isHidden = true
        }
    }
}

// MARK: Layout
extension ListViewController {
    
    private func setupView() {
        // UIViewController Setup
        title = "Pokedex"
        view.backgroundColor = .Theme.backgroundColor
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.clear]
        
        // Add Views
        view.addSubview(collectionView)
        view.addSubview(loadingImageView)
        backgroundView.addSubview(cornerImageView)
        
        // Constraints
        NSLayoutConstraint.activate([
            cornerImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -42),
            cornerImageView.centerXAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -42),
            cornerImageView.heightAnchor.constraint(equalTo: cornerImageView.widthAnchor),
            cornerImageView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.6),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingImageView.heightAnchor.constraint(equalTo: loadingImageView.widthAnchor),
            loadingImageView.widthAnchor.constraint(equalToConstant: 76),
        ])
        loadingImageViewCenterYConstraint = loadingImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        loadingImageViewCenterYConstraint?.isActive = true
    }
}

// MARK: - CollectionView Delegates
extension ListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pokemonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCardCell.reuseID, for: indexPath)
        if let cell = cell as? ListCardCell {
            let pokemon = pokemonList[indexPath.item]
            cell.setup(for: pokemon)
        }
        return cell
    }
}
