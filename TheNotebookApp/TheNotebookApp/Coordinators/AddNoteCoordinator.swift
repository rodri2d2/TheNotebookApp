//
//  AddNoteCoordinator.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit


class AddNoteCoordinator: Coordinator{
    
    // MARK: - Class properties
    private let presenter: UINavigationController
    
    // MARK: - Coordinator protocol properties
    var childrem: [Coordinator] = []
    
    
    init(notePresenter: UINavigationController) {
        self.presenter = notePresenter
    }
    
    // MARK: - Coordinator protocol functionalities
    func start() {
        
        
        
    }
    
    func finish() {
        
    }
    
    
}
