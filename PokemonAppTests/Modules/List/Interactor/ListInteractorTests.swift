//
//  ListInteractorTests.swift
//  PokemonAppTests
//
//  Created by PremierSoft on 15/08/21.
//

import XCTest
@testable import PokemonApp

class ListInteractorTests: XCTestCase {
    
    let presenterMock = ListPresenterMock()
    
    lazy var listInteractor: ListInteractor = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let listInteractor = ListInteractor(session: URLSession(configuration: configuration))
        listInteractor.presenter = presenterMock
        return listInteractor
    }()
    
    
    override func setUp() {
        presenterMock.reset()
    }
    
    private func setRequestHandler(data: Data, statusCode: Int = 200) {
        URLProtocolMock.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
    }
    
    private func pokemonArrayToData(_ pokemonList: [Pokemon]) -> Data {
        let encoder = JSONEncoder()
        return try! encoder.encode(pokemonList)
    }
    
    func testFetchPokemonListEmpty() {
        let pokemonList = [Pokemon]()
        setRequestHandler(data: pokemonArrayToData(pokemonList))
        let expectation = expectation(description: "Fetching Pokemon List Empty")
        presenterMock.expectation = expectation
        listInteractor.fetchPokemonList()
        waitForExpectations(timeout: 5) { _ in
            let presenterMock = self.presenterMock
            XCTAssert(presenterMock.didFetchPokemonListCount == 1)
            guard let result = presenterMock.interactorDidFetchPokemonListArgsResult.first else {
                return XCTFail("Should have at least one result")
            }
            if case .success(let pokemons) = result {
                XCTAssert(pokemons.isEmpty)
            } else {
                XCTFail("Should have returned an empty list")
            }
        }
    }
    
    func testFetchPokemonListOnePokemon() {
        let pokemonList = [Pokemon(id: 0, name: "Test", num: "0", image: "", types: ["test"])]
        setRequestHandler(data: pokemonArrayToData(pokemonList))
        let expectation = expectation(description: "Fetching Pokemon List One Pokemon")
        presenterMock.expectation = expectation
        listInteractor.fetchPokemonList()
        waitForExpectations(timeout: 5) { _ in
            let presenterMock = self.presenterMock
            XCTAssert(presenterMock.didFetchPokemonListCount == 1)
            guard let result = presenterMock.interactorDidFetchPokemonListArgsResult.first else {
                return XCTFail("Should have at least one result")
            }
            if case .success(let pokemons) = result {
                XCTAssert(pokemonList.count == pokemons.count)
                for index in 0..<pokemons.count {
                    let apiPokemon = pokemons[index]
                    let localPokemon = pokemonList[index]
                    XCTAssert(apiPokemon.id == localPokemon.id)
                    XCTAssert(apiPokemon.image == localPokemon.image)
                    XCTAssert(apiPokemon.name == localPokemon.name)
                    XCTAssert(apiPokemon.num == localPokemon.num)
                    XCTAssert(localPokemon.types.count == apiPokemon.types.count)
                    for typeIndex in 0..<localPokemon.types.count {
                        let apiType = apiPokemon.types[typeIndex]
                        let localType = localPokemon.types[typeIndex]
                        XCTAssert(apiType == localType)
                    }
                }
            } else {
                XCTFail("Should have returned a list of pokemon")
            }
        }
    }

    func testFetchPokemonListInvalidData() {
        setRequestHandler(data: Data())
        let expectation = expectation(description: "Fetching Pokemon List Invalid Data")
        presenterMock.expectation = expectation
        listInteractor.fetchPokemonList()
        waitForExpectations(timeout: 5) { _ in
            let presenterMock = self.presenterMock
            XCTAssert(presenterMock.didFetchPokemonListCount == 1)
            guard let result = presenterMock.interactorDidFetchPokemonListArgsResult.first else {
                return XCTFail("Should have at least one result")
            }
            if case .failure(let error) = result {
                XCTAssert(error == .failed)
            } else {
                XCTFail("Should have returned an error type")
            }
        }
    }

    func testFetchPokemonListValidData404StatusCode() {
        let pokemonList = [Pokemon(id: 0, name: "Test", num: "0", image: "", types: ["test"])]
        setRequestHandler(data: pokemonArrayToData(pokemonList), statusCode: 404)
        let expectation = expectation(description: "Fetching Pokemon List Valid Data 404 but with StatusCode")
        presenterMock.expectation = expectation
        listInteractor.fetchPokemonList()
        waitForExpectations(timeout: 5) { _ in
            let presenterMock = self.presenterMock
            XCTAssert(presenterMock.didFetchPokemonListCount == 1)
            guard let result = presenterMock.interactorDidFetchPokemonListArgsResult.first else {
                return XCTFail("Should have at least one result")
            }
            if case .failure(let error) = result {
                XCTAssert(error == .failed)
            } else {
                XCTFail("Should have returned an error type")
            }
        }
    }
}

class ListPresenterMock: ListPresenterProtocol {
    
    var didFetchPokemonListCount = 0
    var interactorDidFetchPokemonListArgsResult = [Result<[Pokemon], ListFetchError>]()
    
    var expectation: XCTestExpectation?
    
    var router: ListRouter?
    var interactor: ListInteractor?
    var view: ListViewProtocol?
    
    func interactorDidFetchPokemonList(with result: Result<[Pokemon], ListFetchError>) {
        didFetchPokemonListCount += 1
        interactorDidFetchPokemonListArgsResult.append(result)
        expectation?.fulfill()
    }
    
    func reset() {
        didFetchPokemonListCount = 0
        interactorDidFetchPokemonListArgsResult.removeAll()
        expectation = nil
    }
}
