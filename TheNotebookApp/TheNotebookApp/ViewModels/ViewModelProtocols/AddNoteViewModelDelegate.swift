//
//  AddNoteViewModelDelegate.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 11/2/21.
//

import Foundation
import CoreData

protocol AddNoteViewModelDelegate {
    func didPhotoSourceChange()
    func didChangeObject(type: NSFetchedResultsChangeType, indexPath: IndexPath, newIndexPath: IndexPath?)
    func didChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>)
}
