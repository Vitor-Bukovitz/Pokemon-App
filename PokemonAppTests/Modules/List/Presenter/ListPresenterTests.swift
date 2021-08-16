//
//  ListPresenterTests.swift
//  PokemonAppTests
//
//  Created by PremierSoft on 16/08/21.
//

import XCTest
@testable import PokemonApp

class ListPresenterTests: XCTestCase {
    
    private let listViewMock = ListViewMock()
    lazy private var listPresenter: ListPresenter = {
        let listPresenter = ListPresenter()
        listPresenter.view = listViewMock
        return listPresenter
    }()
    
    override func setUp() {
        listViewMock.reset()
    }
    
    func testUpdateViewWithEmptyPokemonList() {
        let pokemonList = [Pokemon]()
        let expectation = expectation(description: "Should update view with empty pokemon list")
        listViewMock.expectation = expectation
        listPresenter.interactorDidFetchPokemonList(with: .success(pokemonList))
        waitForExpectations(timeout: 5) { _ in
            let listViewMock = self.listViewMock
            XCTAssert(listViewMock.didUpdateWithPokemonListCount == 1)
            guard let pokemonList = listViewMock.updateWithPokemonListArgs.first else {
                return XCTFail("Should have returned an empty array")
            }
            XCTAssert(pokemonList.isEmpty)
        }
    }
}


class ListViewMock: ListViewProtocol {
    
    var didUpdateWithPokemonListCount = 0
    var didUpdateWithErrorCount = 0
    var updateWithPokemonListArgs = [[Pokemon]]()
    var updateWithErrorArgs = [ListFetchError]()
    
    var expectation: XCTestExpectation?
    
    var presenter: ListPresenterProtocol?
    
    func update(with pokemonList: [Pokemon]) {
        didUpdateWithPokemonListCount += 1
        updateWithPokemonListArgs.append(pokemonList)
        expectation?.fulfill()
    }
    
    func update(with error: ListFetchError) {
        didUpdateWithErrorCount += 1
        updateWithErrorArgs.append(error)
        expectation?.fulfill()
    }
    
    func reset() {
        didUpdateWithPokemonListCount = 0
        didUpdateWithErrorCount = 0
        updateWithPokemonListArgs.removeAll()
        updateWithErrorArgs.removeAll()
    }
}
