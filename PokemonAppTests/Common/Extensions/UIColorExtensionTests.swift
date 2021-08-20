//
//  UIColorExtensionTests.swift
//  PokemonAppTests
//
//  Created by PremierSoft on 19/08/21.
//

import XCTest
@testable import PokemonApp

class UIColorExtensionTests: XCTestCase {
    
    func testRGBInit() {
        // Arrange
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Act
        let resultColor = UIColor(red: 0, green: 0, blue: 0)
        
        // Assert
        XCTAssert(blackColor == resultColor)
    }
    
    func testHEXInit() {
        // Arrange
        let blackColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        
        // Act
        let resultColor = UIColor(0x000000)
        
        // Assert
        XCTAssert(blackColor == resultColor)
    }
}
