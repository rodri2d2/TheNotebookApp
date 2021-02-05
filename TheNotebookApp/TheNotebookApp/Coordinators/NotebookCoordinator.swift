    //
//  NotebookCoordinator.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class NotebookCoordinator: Coordinator{
    
    // MARK: - Class properties
    private let presenter: UINavigationController
    
    // MARK: - Coordinator protocol properties
    var childrem: [Coordinator] = []
    
    
    // MARK: - Lyfecycle
    init(appPresenter: UINavigationController) {
        self.presenter = appPresenter
    }
    
    
    // MARK: - Coordinator protocol functionalities
    func start() {
        //
        let viewModel = NotebookViewModel()
        viewModel.coordinatorDelegate = self
        let notebookController = NotebookViewController(notebookViewModel: viewModel)
        //
        self.presenter.setViewControllers([notebookController], animated: true)
        
    }
    
    func finish() {}

}
    
    
// MARK: - Extension for NotebookCoordinatorDelegate
extension NotebookCoordinator: NotebookCoodinatorDelegate{
    
}
