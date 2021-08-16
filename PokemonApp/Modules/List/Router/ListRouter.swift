//
//  ListRouter.swift
//  PokemonApp
//

import UIKit

typealias ListEntryPoint = ListViewProtocol & UIViewController

protocol ListRouterProtocol {
    /// Variables
    var viewController: ListEntryPoint? { get }
    var navigationController: UINavigationController? { get }
    
    /// Creates and reaturn a ListRouter with the proper setup
    static func start() -> ListRouterProtocol
    
    /// Pushes the view to the DetailView
    func pushDetailController()
}

class ListRouter: ListRouterProtocol {
    
    var viewController: ListEntryPoint?
    var navigationController: UINavigationController?
    
    static func start() -> ListRouterProtocol {
        let router = ListRouter()
        
        // Assign VIP
        let view = ListViewController()
        let interactor = ListInteractor()
        let presenter = ListPresenter()
        
        view.presenter = presenter
        
        interactor.presenter = presenter
        
        presenter.router = router
        presenter.view = view
        presenter.interactor = interactor
        
        router.viewController = view
        router.navigationController = UINavigationController(rootViewController: view)
        
        return router
    }
    
    func pushDetailController() {
        navigationController?.pushViewController(UIViewController(), animated: true)
    }
}
