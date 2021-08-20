//
//  ListPresenterTests.swift
//  PokemonAppTests
//

import XCTest
@testable import PokemonApp

class ListPresenterTests: XCTestCase {
    
    func testUpdateViewWithEmptyPokemonList() {
        // Arrange
        let localPokemonList = [Pokemon]()
        let listViewMock = ListViewMock()
        let listInteractorMock = ListInteractorMock()
        let listPresenter = makeListPresenter(view: listViewMock, interactor: listInteractorMock)
        listViewMock.expectation = expectation(description: "Should update view with empty pokemon list")
        listInteractorMock.result = .success(localPokemonList)
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
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
        let listViewMock = ListViewMock()
        let listInteractorMock = ListInteractorMock()
        listViewMock.expectation = expectation(description: "Should update view with one pokemon in list")
        let listPresenter = makeListPresenter(view: listViewMock, interactor: listInteractorMock)
        listInteractorMock.result = .success(localPokemonList)
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
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
        let listViewMock = ListViewMock()
        let listInteractorMock = ListInteractorMock()
        let listPresenter = makeListPresenter(view: listViewMock, interactor: listInteractorMock)
        listViewMock.expectation = expectation(description: "Should update view with two pokemon in list")
        listInteractorMock.result = .success(localPokemonList)
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        waitForExpectations(timeout: 5) { _ in
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
        let localError = ListFetchError.failed
        let listRouterMock = ListRouterMock()
        let listInteractorMock = ListInteractorMock()
        let listPresenter = makeListPresenter(router: listRouterMock, interactor: listInteractorMock)
        listRouterMock.expectation = expectation(description: "Should update view with error message")
        listInteractorMock.result = .failure(localError)
        
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
        let localPokemonList = [Pokemon]()
        let listInteractorMock = ListInteractorMock()
        let listPresenter = makeListPresenter(interactor: listInteractorMock)
        listInteractorMock.result = .success(localPokemonList)
        
        // Act
        listPresenter.fetchPokemonList()
        
        // Assert
        XCTAssert(listInteractorMock.didFetchPokemonListCount == 1)
    }
    
    func testRouterBeingCalled() {
        // Arrange
        let listRouterMock = ListRouterMock()
        let listPresenter = makeListPresenter(router: listRouterMock)
        
        // Act
        listPresenter.pushDetailController(with: Pokemon(id: 0, name: "", num: "", img: "", type: [.normal]))
        
        // Assert
        XCTAssert(listRouterMock.didPushDetailControllerCount == 1)
    }
    
    
    weak var listPresenterWeak: ListPresenter?
    
    override func tearDown() {
        XCTAssertNil(listPresenterWeak?.view)
        XCTAssertNotNil(listPresenterWeak?.interactor)
        XCTAssertNotNil(listPresenterWeak?.router)
    }
    
    func makeListPresenter(view: ListViewMock = ListViewMock(), router: ListRouterMock = ListRouterMock(), interactor: ListInteractorMock = ListInteractorMock()) -> ListPresenter {
        let listPresenter = ListPresenter()
        listPresenter.view = view
        listPresenter.router = router
        listPresenter.interactor = interactor
        interactor.presenter = listPresenter
        listPresenterWeak = listPresenter
        return listPresenter
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
}
