//
//  ListViewController.swift
//  PokemonApp
//
//  Created by PremierSoft on 15/08/21.
//

import UIKit

protocol ListViewProtocol {
    var presenter: ListPresenterProtocol? { get set }
    func update(with pokemonList: [Pokemon])
    func update(with error: PokemonErrorConstants)
}

class ListViewController: UIViewController, ListViewProtocol {
    
    var presenter: ListPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    func update(with pokemonList: [Pokemon]) {
        
    }
    
    func update(with error: PokemonErrorConstants) {
        
    }
}

