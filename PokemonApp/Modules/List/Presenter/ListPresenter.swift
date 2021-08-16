//
//  ListPresenter.swift
//  PokemonApp
//

import Foundation
import UIKit

enum ListFetchError: String, Error {
    case failed = "The data received from the server is invalid. Please try again later."
}

protocol ListPresenterProtocol {
    /// Variables
    var router: ListRouterProtocol? { get set }
    var interactor: ListInteractorProtocol? { get set }
    var view: ListViewProtocol? { get set }
    
    /// Fetches the pokemon list from the interacotr
    func fetchPokemonList()
    /// Pushes the navigation controller to the detail controller
    func pushDetailController(with pokemon: Pokemon)
    
    /// Called from the interactor with the result of the API call
    func interactorDidFetchPokemonList(with result: Result<[Pokemon], ListFetchError>)
}

class ListPresenter: ListPresenterProtocol {
    
    var router: ListRouterProtocol?
    var interactor: ListInteractorProtocol?
    var view: ListViewProtocol?
    
    func fetchPokemonList() {
        interactor?.fetchPokemonList()
    }
    
    func pushDetailController(with pokemon: Pokemon) {
        router?.pushDetailController()
    }
    
    func interactorDidFetchPokemonList(with result: Result<[Pokemon], ListFetchError>) {
        switch result {
        case .success(let pokemonList):
            view?.update(with: pokemonList)
        case .failure(let error):
            view?.update(with: error)
        }
    }
}
