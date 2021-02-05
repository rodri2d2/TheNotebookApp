//
//  AppCoordinator.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit


/**
 This class controls the entire app navigation based on Coordinator Pattern. It is App Main Coordinator Class
 
  Its start method asign to app Window a rootNavigationController as UINavigationController.
 
 - Author: Rodrigo Candido
 - Version: v1.0
 */
class AppCoordinator: Coordinator{
    
    // MARK: - Class properties
    private var window: UIWindow
 
    // MARK: - Coordinator Protrocol Properties
    var childrem: [Coordinator] = []
    
    // MARK: - Lifecycle
    init(appWindow: UIWindow) {
        self.window = appWindow
    }
    
    // MARK: - Coordinator Protrocol Functionalities
    func start() {
        //
        let navigationController = UINavigationController()
        //
        let notebookCoordinator = NotebookCoordinator(appPresenter: navigationController)
        self.childrem.append(notebookCoordinator)
        notebookCoordinator.start()
        //
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    func finish() {
        
    }
    
}
