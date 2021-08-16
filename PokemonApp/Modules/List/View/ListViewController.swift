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
    /// Called from the presenter to update the view with the error returned from the interactor
    func update(with error: ListFetchError)
}

class ListViewController: UIViewController, ListViewProtocol {
    
    var presenter: ListPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed
        // Do any additional setup after loading the view.
    }
    
    
    func update(with pokemonList: [Pokemon]) {
        
    }
    
    func update(with error: ListFetchError) {
        
    }
}

