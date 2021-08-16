//
//  ListInteractor.swift
//  PokemonApp
//

import Foundation

protocol ListInteractorProtocol {
    /// Variables
    var presenter: ListPresenterProtocol? { get set }
    
    /// Calls the https://api.jsonbin.io/b/6118b227e1b0604017b05f6f endpoint.
    ///
    /// Returns either a `ListFetchError` or `[Pokemon]`
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
            guard let self = self,
                  let data = data,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                self?.presenter?.interactorDidFetchPokemonList(with: .failure(.failed))
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
