//
//  ListRouterTests.swift
//  PokemonAppTests
//

import XCTest
@testable import PokemonApp

class ListRouterTests: XCTestCase {

    private let router = ListRouter.start()
    
    private func wait(for duration: TimeInterval) {
      let waitExpectation = expectation(description: "Waiting")

      let when = DispatchTime.now() + duration
      DispatchQueue.main.asyncAfter(deadline: when) {
        waitExpectation.fulfill()
      }

      // We use a buffer here to avoid flakiness with Timer on CI
      waitForExpectations(timeout: duration + 0.5)
    }
    
    func testVIPComponentsInRouterNotNil() {
        let view = router.viewController
        let presenter = view?.presenter
        let interactor = presenter?.interactor
        
        // View Components
        XCTAssert(view?.presenter != nil)
        
        // Interactor Components
        XCTAssert(interactor?.presenter != nil)
        
        // Presenter Components
        XCTAssert(presenter?.router != nil)
        XCTAssert(presenter?.view != nil)
        XCTAssert(presenter?.interactor != nil)
    }
    
    func testPushViewControllerBeingCalled() {
        XCTAssert(router.navigationController?.topViewController is ListViewController)
        router.pushDetailController()
        wait(for: 1)
        XCTAssertFalse(router.navigationController?.topViewController is ListViewController)
    }
}
