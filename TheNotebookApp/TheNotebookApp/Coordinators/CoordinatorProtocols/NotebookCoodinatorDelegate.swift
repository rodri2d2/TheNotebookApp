//
//  NotebookCoodinatorDelegare.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation

protocol NotebookCoodinatorDelegate {
    func didSelectANotebook(notebook: NotebookMO)
    func childDidFinish()
}
