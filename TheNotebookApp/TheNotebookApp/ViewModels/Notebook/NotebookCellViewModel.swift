//
//  NotebookCellViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation

class NotebookCellViewModel {
    
    private let notebook: NotebookMO
    var title:         String
    var description:   String
    var createdAt:     Date
    var numberOfNotes: Int
    
    init(notebookItem: NotebookMO) {
        self.notebook    = notebookItem
        self.title       = notebook.title!
        self.description = notebook.notebookDesc!
        self.createdAt   = notebook.createdAt!
        self.numberOfNotes = notebook.hasMany!.count
    }
    
    func notebookModel() -> NotebookMO{
        return self.notebook
    }
}
