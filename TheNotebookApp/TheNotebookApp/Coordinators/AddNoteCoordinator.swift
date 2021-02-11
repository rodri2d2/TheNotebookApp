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
    private var addNoteNavigationController: UINavigationController?
    private let dataManager: LocalDataManager
    private let notebook: NotebookMO
    var onCancel:  (() -> Void)?
    var onCreated: (() -> Void)?
    
    // MARK: - Coordinator protocol properties
    var childrem: [Coordinator] = []
    
    
    init(notePresenter: UINavigationController, localDataManager: LocalDataManager, belongsTo: NotebookMO) {
        self.presenter = notePresenter
        self.dataManager = localDataManager
        self.notebook = belongsTo
        
    }
    
    // MARK: - Coordinator protocol functionalities
    func start() {
        
        let addNoteViewModel = AddNoteViewModel(localDataManager: self.dataManager, notebook: self.notebook)
        addNoteViewModel.coordinatorDelegate = self
        
        let noteViewController = AddNoteViewController(addNoteViewModel: addNoteViewModel)
        let navigationController = UINavigationController(rootViewController: noteViewController)
        
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .flipHorizontal
        
        
        self.addNoteNavigationController = navigationController
        self.presenter.present(navigationController, animated: true, completion: nil)
    }
    
    func finish() {
        addNoteNavigationController?.dismiss(animated: true, completion: nil)
    }
    
}

extension AddNoteCoordinator: AddNoteCoodinatorDelegate{
    func didCreated() {
        onCreated?()
    }
    
    func didCancel() {
        onCancel?()
    }
}
