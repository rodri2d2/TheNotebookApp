//
//  NoteCellViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation

class NoteListCellViewModel{
    
    private let note: NoteMO
    var noteTitle:    String
    var noteContent:  String
    
    init(noteMO: NoteMO) {
        self.note = noteMO
        self.noteTitle  = note.title!
        self.noteContent = note.noteContent!
    }
    
    func noteModel()->NoteMO{
        return self.note
    }
    
}
