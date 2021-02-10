//
//  NoteViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation

class NoteListViewModel{
    
    // MARK: - Class properties
    var title: String
    var delegate:            NoteListViewModelDelegate?
    var coordinatorDelegate: NoteListCoordinatorDelegate?
    var cells:               [NoteListCellViewModel] = []
    private var notebook:    NotebookMockModel
    
    
    // MARK: - Lifecycle
    init(notebook: NotebookMockModel) {
        self.notebook = notebook
        self.title = notebook.title
    }
    
    // MARK: - Class functionalities
    func plusButtonWasPressed(){
        self.coordinatorDelegate?.didPressPlusButton()
    }
    
}
