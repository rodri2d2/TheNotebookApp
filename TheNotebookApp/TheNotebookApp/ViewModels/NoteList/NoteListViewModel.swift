//
//  NoteViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation

class NoteListViewModel{
    
    var title: String
    var delegate: NoteListViewModelDelegate?
    private var notebook: NotebookMockModel
    
    
    init(notebook: NotebookMockModel) {
        self.notebook = notebook
        self.title = notebook.title
    }
    
}
