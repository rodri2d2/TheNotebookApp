//
//  NoteViewModelDelegate.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation
import CoreData

protocol NoteListViewModelDelegate {
    func dataDidChange(type: NSFetchedResultsChangeType, indexPath: IndexPath, isRemovingAll: Bool)
}
