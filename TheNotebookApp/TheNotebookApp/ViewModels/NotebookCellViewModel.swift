//
//  NotebookCellViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation


class NotebookCellViewModel {
    
    private let notebook: NotebookMockModel
    var title:       String
    var description: String
    var createdAt:   Date
    
    init(notebookItem: NotebookMockModel) {
        self.notebook    = notebookItem
        self.title       = notebook.title
        self.description = notebook.decription
        self.createdAt   = notebook.createdAt
    }
}
