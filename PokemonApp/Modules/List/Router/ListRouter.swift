//
//  ListRouter.swift
//  PokemonApp
//
//  Created by PremierSoft on 15/08/21.
//

import UIKit

typealias ListEntryPoint = ListViewProtocol & UIViewController

protocol ListRouterProtocol {
    var viewController: ListEntryPoint? { get }
    static func start() -> ListRouterProtocol
}

class ListRouter: ListRouterProtocol {
    
    var viewController: ListEntryPoint?
    
    static func start() -> ListRouterProtocol {
        let router = ListRouter()
        
        // Assign VIP
        
        return router
    }
}
