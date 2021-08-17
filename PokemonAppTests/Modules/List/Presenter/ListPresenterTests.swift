//
//  ListPresenterTests.swift
//  PokemonAppTests
//

import XCTest
@testable import PokemonApp

class ListPresenterTests: XCTestCase {
    
    private let listViewMock = ListViewMock()
    private let interactorMock = ListInteractorMock()
    lazy private var listPresenter: ListPresenter = {
        let listPresenter = ListPresenter()
        listPresenter.view = listViewMock
        return listPresenter
    }()
    
    override func setUp() {
        listViewMock.reset()
        interactorMock.reset()
        interactorMock.presenter = listPresenter
        listPresenter.interactor = interactorMock
    }
    
    func testUpdateViewWithEmptyPokemonList() {
        // Arrange
        let localPokemonList = [Pokemon]()
        listViewMock.expectation = expectation(description: "Should update view with empty pokemon list")
        interactorMock.result = .success(localPokemonList)
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
            let listViewMock = self.listViewMock
            XCTAssert(listViewMock.didUpdateWithPokemonListCount == 1)
            guard let pokemonList = listViewMock.updateWithPokemonListArgs.first else {
                return XCTFail("Should have returned an empty array")
            }
            XCTAssert(pokemonList.isEmpty)
        }
    }
    
    func testUpdateViewWithOnePokemonInList() {
        // Arrange
        let localPokemonList = [Pokemon(id: 1, name: "test", num: "", img: "", type: [.normal])]
        listViewMock.expectation = expectation(description: "Should update view with one pokemon in list")
        interactorMock.result = .success(localPokemonList)
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
            let listViewMock = self.listViewMock
            XCTAssert(listViewMock.didUpdateWithPokemonListCount == 1)
            guard let pokemonList = listViewMock.updateWithPokemonListArgs.first else {
                return XCTFail("Should have returned an array with one pokemon in list")
            }
            XCTAssert(pokemonList.count == 1)
            for index in 0..<pokemonList.count {
                let localPokemon = localPokemonList[index]
                let apiPokemon = pokemonList[index]
                XCTAssert(localPokemon.id == apiPokemon.id)
                XCTAssert(localPokemon.img == apiPokemon.img)
                XCTAssert(localPokemon.name == apiPokemon.name)
                XCTAssert(localPokemon.num == apiPokemon.num)
                XCTAssert(localPokemon.type == apiPokemon.type)
            }
        }
    }
    
    func testUpdateViewWithTwoPokemonInList() {
        // Arrange
        let localPokemonList = [
            Pokemon(id: 1, name: "test", num: "", img: "", type: [.normal]),
            Pokemon(id: 1, name: "test", num: "", img: "", type: [.normal])
        ]
        listViewMock.expectation = expectation(description: "Should update view with two pokemon in list")
        interactorMock.result = .success(localPokemonList)
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
            let listViewMock = self.listViewMock
            XCTAssert(listViewMock.didUpdateWithPokemonListCount == 1)
            guard let pokemonList = listViewMock.updateWithPokemonListArgs.first else {
                return XCTFail("Should have returned an array with two pokemon in list")
            }
            XCTAssert(pokemonList.count == 2)
            for index in 0..<pokemonList.count {
                let localPokemon = localPokemonList[index]
                let apiPokemon = pokemonList[index]
                XCTAssert(localPokemon.id == apiPokemon.id)
                XCTAssert(localPokemon.img == apiPokemon.img)
                XCTAssert(localPokemon.name == apiPokemon.name)
                XCTAssert(localPokemon.num == apiPokemon.num)
                XCTAssert(localPokemon.type == apiPokemon.type)
            }
        }
    }
    
    func testUpdateViewWithError() {
        // Arrange
        let listRouterMock = ListRouterMock()
        let localError = ListFetchError.failed
        listPresenter.router = listRouterMock
        listRouterMock.expectation = expectation(description: "Should update view with error message")
        interactorMock.result = .failure(localError)
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
            XCTAssert(listRouterMock.didShowAlertControllerCount == 1)
            XCTAssert(listRouterMock.showAlertControllerArgs.first == localError.rawValue)
        }
    }
    
    func testInteractorBeingCalled() {
        // Arrange
        interactorMock.result = .success([])
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        XCTAssert(interactorMock.didFetchPokemonListCount == 1)
    }
    
    func testRouterBeingCalled() {
        // Arrange
        let listRouterMock = ListRouterMock()
        listPresenter.router = listRouterMock
        
        // Act
        listPresenter.pushDetailController(with: Pokemon(id: 0, name: "", num: "", img: "", type: [.normal]))
        
        // Assert
        XCTAssert(listRouterMock.didPushDetailControllerCount == 1)
    }
}


class ListViewMock: ListViewProtocol {
    
    var didUpdateWithPokemonListCount = 0
    var updateWithPokemonListArgs = [[Pokemon]]()
    
    var expectation: XCTestExpectation?
    
    var presenter: ListPresenterProtocol?
    
    func update(with pokemonList: [Pokemon]) {
        didUpdateWithPokemonListCount += 1
        updateWithPokemonListArgs.append(pokemonList)
        expectation?.fulfill()
    }
    
    func reset() {
        didUpdateWithPokemonListCount = 0
        updateWithPokemonListArgs.removeAll()
    }
}

class ListInteractorMock: ListInteractorProtocol {
    
    var didFetchPokemonListCount = 0
    var result: Result<[Pokemon], ListFetchError>?
    
    var presenter: ListPresenterProtocol?
    
    func fetchPokemonList() {
        guard let result = result else {
            return XCTFail("You should set a result return for the ListInteractorMock")
        }
        didFetchPokemonListCount += 1
        presenter?.interactorDidFetchPokemonList(with: result)
    }
    
    func reset() {
        didFetchPokemonListCount = 0
        result = nil
    }
}

class ListRouterMock: ListRouterProtocol {
    
    var didPushDetailControllerCount = 0
    var didShowAlertControllerCount = 0
    
    var showAlertControllerArgs = [String]()
    
    var expectation: XCTestExpectation?
    
    var viewController: ListEntryPoint?
    var navigationController: UINavigationController?
    
    static func start() -> ListRouterProtocol {
        return ListRouterMock()
    }
    
    func pushDetailController() {
        didPushDetailControllerCount += 1
    }
    
    func showAlertController(title: String, message: String, completion: (() -> Void)?) {
        didShowAlertControllerCount += 1
        showAlertControllerArgs.append(message)
        expectation?.fulfill()
    }
    
    func reset() {
        didPushDetailControllerCount = 0
        didShowAlertControllerCount = 0
        showAlertControllerArgs.removeAll()
    }
}
