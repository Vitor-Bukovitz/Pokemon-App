//
//  ListInteractorTests.swift
//  PokemonAppTests
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
        // Arrange
        let localPokemonList = [Pokemon]()
        setRequestHandler(data: pokemonArrayToData(localPokemonList))
        presenterMock.expectation = expectation(description: "Fetching Pokemon List Empty")
        
        // Act
        listInteractor.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
            let presenterMock = self.presenterMock
            XCTAssert(presenterMock.didFetchPokemonListCount == 1)
            guard let result = presenterMock.interactorDidFetchPokemonListArgsResult.first else {
                return XCTFail("Should have at least one result")
            }
            if case .success(let pokemonList) = result {
                XCTAssert(pokemonList.isEmpty)
            } else {
                XCTFail("Should have returned an empty list")
            }
        }
    }
    
    func testFetchPokemonListOnePokemon() {
        // Arrange
        let localPokemonList = [Pokemon(id: 0, name: "Test", num: "0", image: "", types: ["test"])]
        setRequestHandler(data: pokemonArrayToData(localPokemonList))
        presenterMock.expectation = expectation(description: "Fetching Pokemon List One Pokemon")
        
        // Act
        listInteractor.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
            let presenterMock = self.presenterMock
            XCTAssert(presenterMock.didFetchPokemonListCount == 1)
            guard let result = presenterMock.interactorDidFetchPokemonListArgsResult.first else {
                return XCTFail("Should have at least one result")
            }
            if case .success(let pokemonList) = result {
                XCTAssert(pokemonList.count == localPokemonList.count)
                for index in 0..<pokemonList.count {
                    let apiPokemon = pokemonList[index]
                    let localPokemon = localPokemonList[index]
                    XCTAssert(apiPokemon.id == localPokemon.id)
                    XCTAssert(apiPokemon.image == localPokemon.image)
                    XCTAssert(apiPokemon.name == localPokemon.name)
                    XCTAssert(apiPokemon.num == localPokemon.num)
                    XCTAssert(localPokemon.types == apiPokemon.types)
                }
            } else {
                XCTFail("Should have returned a list of pokemon")
            }
        }
    }
    
    func testFetchPokemonListTwoPokemon() {
        // Arrange
        let localPokemonList = [
            Pokemon(id: 0, name: "Test", num: "0", image: "", types: ["test"]),
            Pokemon(id: 0, name: "Test", num: "0", image: "", types: ["test"])
        ]
        setRequestHandler(data: pokemonArrayToData(localPokemonList))
        presenterMock.expectation = expectation(description: "Fetching Pokemon List One Pokemon")
        
        // Act
        listInteractor.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
            let presenterMock = self.presenterMock
            XCTAssert(presenterMock.didFetchPokemonListCount == 1)
            guard let result = presenterMock.interactorDidFetchPokemonListArgsResult.first else {
                return XCTFail("Should have at least one result")
            }
            if case .success(let pokemonList) = result {
                XCTAssert(localPokemonList.count == pokemonList.count)
                for index in 0..<pokemonList.count {
                    let apiPokemon = pokemonList[index]
                    let localPokemon = localPokemonList[index]
                    XCTAssert(apiPokemon.id == localPokemon.id)
                    XCTAssert(apiPokemon.image == localPokemon.image)
                    XCTAssert(apiPokemon.name == localPokemon.name)
                    XCTAssert(apiPokemon.num == localPokemon.num)
                    XCTAssert(localPokemon.types == apiPokemon.types)
                }
            } else {
                XCTFail("Should have returned a list of pokemon")
            }
        }
    }
    
    func testFetchPokemonListInvalidData() {
        // Arrange
        setRequestHandler(data: Data())
        presenterMock.expectation = expectation(description: "Fetching Pokemon List Invalid Data")
        
        // Act
        listInteractor.fetchPokemonList()
        
        // Assert
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
        // Arrange
        let pokemonList = [Pokemon(id: 0, name: "Test", num: "0", image: "", types: ["test"])]
        setRequestHandler(data: pokemonArrayToData(pokemonList), statusCode: 404)
        presenterMock.expectation = expectation(description: "Fetching Pokemon List Valid Data 404 but with StatusCode")
        
        // Act
        listInteractor.fetchPokemonList()
        
        // Assert
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
    
    var router: ListRouterProtocol?
    var interactor: ListInteractorProtocol?
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
    
    func fetchPokemonList() {
        interactor?.fetchPokemonList()
    }
    
    func pushDetailController(with pokemon: Pokemon) {
        router?.pushDetailController()
    }
}
