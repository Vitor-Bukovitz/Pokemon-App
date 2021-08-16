//
//  ListInteractor.swift
//  PokemonApp
//
//  Created by PremierSoft on 15/08/21.
//

import Foundation

protocol ListInteractorProtocol {
    var presenter: ListPresenterProtocol? { get set }
    func fetchPokemonList()
}

class ListInteractor: ListInteractorProtocol {
    
    var presenter: ListPresenterProtocol?
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchPokemonList() {
        guard var url = URL(string: NetworkConstants.baseURL) else { return }
        url.appendPathComponent(NetworkConstants.Pokemon.pokemonList)
        session.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                self.presenter?.interactorDidFetchPokemonList(with: .failure(.failed))
                return
            }
            do {
                let decoder = JSONDecoder()
                let pokemonList = try decoder.decode([Pokemon].self, from: data)
                self.presenter?.interactorDidFetchPokemonList(with: .success(pokemonList))
            } catch {
                self.presenter?.interactorDidFetchPokemonList(with: .failure(.failed))
            }
        }.resume()
    }
}
