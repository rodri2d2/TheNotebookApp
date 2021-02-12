//
//  Note+CoreDataClass.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 10/2/21.
//
//

import Foundation
import CoreData


public class NoteMO: NSManagedObject {
    
    static func createNote(title: String, content: String, belongsTo: NotebookMO, in managedObjectContext: NSManagedObjectContext) -> NoteMO? {
        
        let note = NSEntityDescription.insertNewObject(forEntityName: "Note",
                                                       into: managedObjectContext) as? NoteMO
        note?.title         = title
        note?.noteContent   = content
        note?.belongsTo     = belongsTo
        return note
        
    }
    
}
