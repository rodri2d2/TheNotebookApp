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
    private var notebook: NotebookMO?
    private var note:     NoteMO?
    var onCancel:  (() -> Void)?
    var onCreated: (() -> Void)?
    
    // MARK: - Coordinator protocol properties
    var childrem: [Coordinator] = []
    
    
    init(notePresenter: UINavigationController, localDataManager: LocalDataManager) {
        self.presenter = notePresenter
        self.dataManager = localDataManager
    }
    
    // MARK: - Coordinator protocol functionalities
    func start() {

        if let belongsTo = self.notebook {
            let addViewModel = prepareViewModel()
            addViewModel.addNotebook(notebook: belongsTo)
            addViewModel.setMode(mode: .create)
            presentController(viewModel: addViewModel)
        }
        
        if let noteInNotebook = self.note{
            let addViewModel = prepareViewModel()
            addViewModel.addNote(note: noteInNotebook)
            addViewModel.setMode(mode: .edit)
            presentController(viewModel: addViewModel)
        }
    }
    
    private func prepareViewModel() -> AddNoteViewModel{
        let addNoteViewModel = AddNoteViewModel(localDataManager: self.dataManager)
        addNoteViewModel.coordinatorDelegate = self
        return addNoteViewModel
    }
    
    private func presentController(viewModel: AddNoteViewModel){
        let noteViewController = AddNoteViewController(addNoteViewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: noteViewController)
        viewModel.delegate = noteViewController
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .flipHorizontal
        
        self.addNoteNavigationController = navigationController
        self.presenter.present(navigationController, animated: true, completion: nil)
    }
    
    func addNotebook(notebookMO: NotebookMO){
        self.notebook = notebookMO
    }
    
    func addNote(noteMO: NoteMO){
        self.note = noteMO
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
