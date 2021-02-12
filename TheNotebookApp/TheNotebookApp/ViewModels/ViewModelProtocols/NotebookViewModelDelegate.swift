//
//  NotebookViewModelDelegate.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation

/**
 This procotol links the NotebookViewModel to a UI Manager Class
 
 Implement this protocol whenever a change on ViewModel Properties must also be effective for UI
 
 - Attention: Better to implement this on a ViewController Class
 
 - Author: Rodrigo Candido
 - Version: v1.0
 */
protocol NotebookViewModelDelegate {
    func dataDidChange()
}
