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
        private let dataManager: LocalDataManager
        
        // MARK: - Coordinator protocol properties
        var childrem: [Coordinator] = []
        
        
        // MARK: - Lyfecycle
        init(appPresenter: UINavigationController, localDataManager: LocalDataManager) {
            self.presenter = appPresenter
            self.dataManager = localDataManager
        }
        
        
        // MARK: - Coordinator protocol functionalities
        func start() {
            //
            let viewModel = NotebookViewModel(localDataManager: self.dataManager)
            
            
            viewModel.coordinatorDelegate = self
            let notebookController = NotebookListViewController(notebookViewModel: viewModel)
            //
            self.presenter.setViewControllers([notebookController], animated: true)
            
        }
        
        func finish() {}
        
    }
    
    
    // MARK: - Extension for NotebookCoordinatorDelegate
    extension NotebookCoordinator: NotebookCoodinatorDelegate{
        
        
        func didSelectANotebook(notebook: NotebookMO) {
            //
            let noteViewModel = NoteListViewModel(notebook: notebook, localDataManager: self.dataManager)
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

        
        
        private func prepareAddCoodinator() -> AddNoteCoordinator {
            let addNoteCoordinator = AddNoteCoordinator(notePresenter: self.presenter, localDataManager: self.dataManager)
            self.childrem.append(addNoteCoordinator)
            return addNoteCoordinator
        }
        
        func didSelectNote(note: NoteMO) {
            let addNoteCoordinator = prepareAddCoodinator()
            addNoteCoordinator.addNote(noteMO: note)
            addNoteCoordinator.start()
            
            addNoteCoordinator.onCreated = { [weak self] in
                guard let self = self else { return }
//                self.dataManager.saveContext()
                addNoteCoordinator.finish()
                self.childrem.removeAll()
                
            }
            
            addNoteCoordinator.onCancel = {[weak self] in
                guard let self = self else { return }
                addNoteCoordinator.finish()
                
                //TODO: - For next version of this app, change Coordinador, to be much easier to remove a Child Coordinator. This app actually has only one child so the code below is aceptable
                self.childrem.removeAll()
            }
        }
        
        
        func didPressPlusButton(belongsTo: NotebookMO) {
            
            let addNoteCoordinator = prepareAddCoodinator()
            addNoteCoordinator.addNotebook(notebookMO: belongsTo)
            addNoteCoordinator.start()
            
            addNoteCoordinator.onCreated = { [weak self] in
                guard let self = self else { return }
//                self.dataManager.saveContext()
                addNoteCoordinator.finish()
                self.childrem.removeAll()
                
            }
            
            addNoteCoordinator.onCancel = {[weak self] in
                guard let self = self else { return }
                addNoteCoordinator.finish()
                
                //TODO: - For next version of this app, change Coordinador, to be much easier to remove a Child Coordinator. This app actually has only one child so the code below is aceptable
                self.childrem.removeAll()
            }
        }
    }
