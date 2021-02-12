//
//  LocalDataManager.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 10/2/21.
//

import Foundation
import CoreData

class LocalDataManager{
    
    // MARK: - Class properties
    private var persistentContainer: NSPersistentContainer!
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    
    // MARK: - Lifecycle
    /// Initialize NSPersistentContainer
    /// - Parameters:
    ///   - modelName: The managed object model to be used by the persistent container.
    ///   - optionalStoreName: The name used by the persistent container.
    init(modelName: String, optionalStoreName: String?) {
        let managedObjectModel = setManageObjectModel(name: modelName)
        let persistentName = optionalStoreName ?? modelName
        self.persistentContainer = NSPersistentContainer(name: persistentName, managedObjectModel: managedObjectModel)
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            persistentContainer.loadPersistentStores(completionHandler: {(_, error) in               
                if let error = error {
                    fatalError("Couldn't load CoreData Stack \(error.localizedDescription)")
                }
            })
        }
    }
    
    
    // MARK: - Class functionalities
    /// Saves all data from Context into Storage if a change has been detected
    func saveContext() {
        if self.viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func deleteAll(entityName: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
         do {
             let results = try viewContext.fetch(fetchRequest)
             for object in results {
                viewContext.delete(object as! NSManagedObject)
             }
         } catch let error {
             print("Detele all data in \(entityName) error :", error)
         }
    }
    
    
    func resetContext() {
        self.viewContext.reset()
    }
    
    
    /// Initializes the managed object model using the model file at the specified URL.
    /// - Parameter name: as String
    /// - Returns: NSManagedObjectModel
    private func setManageObjectModel(name: String) -> NSManagedObjectModel{
        //
        guard let modelURL = Bundle.main.url(forResource: name, withExtension: "momd") else {
            fatalError("Error could not find model.")
        }
        //
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing managedObjectModel from: \(modelURL).")
        }
        //
        return managedObjectModel
    }
    
    
    func performInBackground(_ block: @escaping (NSManagedObjectContext) -> Void) {
        //creamos nuestro managedobjectcontext privado
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        //seteamos nuestro viewcontext
        privateMOC.parent = viewContext
        //ejecutamos el block dentro de este privateMOC.
        privateMOC.perform {
            block(privateMOC)
        }
    }
    
}
