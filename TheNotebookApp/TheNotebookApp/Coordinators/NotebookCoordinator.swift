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
        let notebookController = NotebookListViewController(notebookViewModel: viewModel)
        //
        self.presenter.setViewControllers([notebookController], animated: true)
        
    }
    
    func finish() {}

}
    
    
// MARK: - Extension for NotebookCoordinatorDelegate
    extension NotebookCoordinator: NotebookCoodinatorDelegate{
        
        
        func didSelectANotebook(noteBook: NotebookMockModel) {
            //
            let noteViewModel = NoteListViewModel(notebook: noteBook)
            let noteListViewController = NoteListViewController(noteViewModel: noteViewModel)
            noteViewModel.delegate = noteListViewController
            noteViewModel.coordinatorDelegate = self
            
            //
            self.presenter.pushViewController(noteListViewController, animated: true)
        }
        
        
        func childDidFinish() {
            
        }
}
// MARK: - Extension for NoteListCoordinatorDelegate
extension NotebookCoordinator: NoteListCoordinatorDelegate{
    func didPressPlusButton() {
        
        let addNoteCoordinator = AddNoteCoordinator(notePresenter: self.presenter)
        self.childrem.append(addNoteCoordinator)
        addNoteCoordinator.start()
        
        addNoteCoordinator.onCancel = {[weak self] in
            guard let self = self else { return }
            addNoteCoordinator.finish()
            
            //TODO: - For next version of this app, change Coordinador, to be much easier to remove a Child Coordinator. This app actually has only one child so the code below is aceptable 
            self.childrem.removeAll()
        }
    }
}
