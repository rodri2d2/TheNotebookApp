//
//  NoteViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation


class AddNoteViewModel {
    
    // MARK: - Class properties
    var delegate:            NoteViewModelDelegate?
    var coordinatorDelegate: AddNoteCoodinatorDelegate?
    private var dataManager: LocalDataManager
    private var notebook: NotebookMO
    
    // MARK: - Lifecycle
    init(localDataManager: LocalDataManager, notebook: NotebookMO) {
        self.dataManager = localDataManager
        self.notebook = notebook
    }
    
    // MARK: - Class functionalities
    func createButtonWasPressed(title: String, content: String){
        
        let _ = NoteMO.createNote(title: title, content: content, belongsTo: self.notebook, in: dataManager.viewContext)
        
        self.coordinatorDelegate?.didCreated()
        
    }
    
    func cancelButtonWasPressed(){
        self.coordinatorDelegate?.didCancel()
    }
     
}
