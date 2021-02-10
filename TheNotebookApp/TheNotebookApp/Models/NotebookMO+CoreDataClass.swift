//
//  NotebookMO+CoreDataClass.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 10/2/21.
//
//

import Foundation
import CoreData


public class NotebookMO: NSManagedObject {
    
    static func createNotebook(title: String, description: String, createAt: Date, in managedObjectContext: NSManagedObjectContext) -> NotebookMO? {
    
        let notebook = NSEntityDescription.insertNewObject(forEntityName: "Notebook",
                                                           into: managedObjectContext) as? NotebookMO
        notebook?.createdAt     = createAt
        notebook?.title         = title
        notebook?.notebookDesc  = description
        
        return notebook
        
    }
}
