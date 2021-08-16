//
//  ListPresenter.swift
//  PokemonApp
//
//  Created by PremierSoft on 15/08/21.
//

import Foundation

protocol ListPresenterProtocol {
    var router: ListRouter? { get set }
    var interactor: ListInteractor? { get set }
    var view: ListViewProtocol? { get set }
    func interactorDidFetchPokemonList(with result: Result<[Pokemon], PokemonErrorConstants>)
}

class ListPresenter: ListPresenterProtocol {
    var router: ListRouter?
    
    var interactor: ListInteractor?
    
    var view: ListViewProtocol?
    
    func interactorDidFetchPokemonList(with result: Result<[Pokemon], PokemonErrorConstants>) {
        
    }
}
