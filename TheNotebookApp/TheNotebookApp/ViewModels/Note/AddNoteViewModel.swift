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

    // MARK: - Lifecycle
    
    
    // MARK: - Class functionalities
    func cancelButtonWasPressed(){
        self.coordinatorDelegate?.didCancel()
    }
     
}
