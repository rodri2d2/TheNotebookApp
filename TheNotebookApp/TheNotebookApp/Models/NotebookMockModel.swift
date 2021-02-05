//
//  NotebookMockModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation

struct NotebookMockModel {
    let title:      String
    let decription: String
    let createdAt:  Date
    let notas: [NoteMockModel]?
}


struct NotebookMockData {
    
    static func notebooks()->[NotebookMockModel]{
        return [
            NotebookMockModel(title: "Notebook 1", decription: "Description 1", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 2", decription: "Description 2", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 3", decription: "Description 3", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 4", decription: "Description 4", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 5", decription: "Description 5", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 6", decription: "Description 6", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 7", decription: "Description 7", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 8", decription: "Description 8", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 9", decription: "Description 9", createdAt: Date(), notas: nil),
            NotebookMockModel(title: "Notebook 10", decription: "Description 10", createdAt: Date(), notas: nil),
        ]
    }
    
}
