//
//  NoteListCoordinatorDelegate.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation

protocol NoteListCoordinatorDelegate {
    func didSelectNote(note: NoteMO)
    func didPressPlusButton(belongsTo: NotebookMO)
}
