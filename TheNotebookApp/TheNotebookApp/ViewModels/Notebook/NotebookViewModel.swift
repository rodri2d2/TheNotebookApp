//
//  NotebookViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation
import CoreData

/**
 This class will handle all Notebook Data related operations
 
 - Attention: This class has a Delegate to notify changes on the view and a CoordinatorDelegate to notify Navigation requests
 
 - Author: Rodrigo Candido
 - Version: v1.0
 */
class NotebookViewModel: NSObject{
    
    // MARK: - Class properties
    var fetchResultsController:  NSFetchedResultsController<NSFetchRequestResult>?
    var coordinatorDelegate: NotebookCoodinatorDelegate?
    var delegate:            NotebookViewModelDelegate?
    private var dataManager: LocalDataManager
    private var cells:       [NotebookCellViewModel] = []
    let title = "Notebooks"
    
    
    // MARK: - Lifecycle
    init(localDataManager: LocalDataManager) {
        self.dataManager = localDataManager
        super.init()
    }
    
    // MARK: - Class functionalities
    //CoreData Related
    private func setupResultController(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notebook")
        let notebookNameSortDescriptor = NSSortDescriptor(key: "createdAt",
                                                          ascending: true)
        request.sortDescriptors = [notebookNameSortDescriptor]
        self.fetchResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                 managedObjectContext: dataManager.viewContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        self.fetchResultsController?.delegate = self
        
        do {
            try self.fetchResultsController?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    //View Related
    
    /// Should be called when the ViewController that hadles its View content from this ViewModel has finish load view - OnViewDidLoad
    func viewWasLoad(){
        //Do some DB load
        self.setupResultController()
    }
    
    
    /// This function will be called whenever a tableView needs to now how many row to load up
    /// - Parameter section: type of Int
    /// - Returns: type of Int
    func numberOfRows(in section: Int) -> Int{
        if let fetchResultsController = fetchResultsController {
            return fetchResultsController.sections![section].numberOfObjects
        }
        return self.cells.count
    }
    
    
    /// This function will be called whenever a cell load up on the screen
    /// - Parameter indexPath: type of IndexPath
    /// - Returns: type of NotebookCellViewModel
    func cellWasLoad(at indexPath: IndexPath) -> NotebookCellViewModel? {
        guard let notebook = fetchResultsController?.object(at: indexPath) as? NotebookMO else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let notebookCell = NotebookCellViewModel(notebookItem: notebook)
        cells.append(notebookCell)
        return notebookCell
    }
    
    
    /// Trigger this function when select a cell
    /// - Parameter indexPath: type of IndexPath
    func cellWasSelected(at indexPath: IndexPath) {
        guard let notebook = fetchResultsController?.object(at: indexPath) as? NotebookMO else {
            fatalError("Attempt to configure cell without a managed object")
        }
        self.coordinatorDelegate?.didSelectANotebook(notebook: notebook)
    }
    
    
    //Actions Related
    /// Trigger this function to add a new Notebook
    /// - Parameters:
    ///   - title: type of String
    ///   - description: type of String
    func plusButtonWasPressed(title: String, description: String){
        //
        guard let notebook =  NotebookMO.createNotebook(title: title, description: description, createAt: Date(), in: self.dataManager.viewContext) else {return}
        //
        self.dataManager.saveContext()
        //
        cells.append(NotebookCellViewModel(notebookItem: notebook))
    }
    
    func updaButtonWasPressed(title: String, description: String, at indexPath: IndexPath){
        let notebook = cells[indexPath.row].notebookModel()
        notebook.title = title
        notebook.notebookDesc = description
        
    }
    
    func deleteNotebookWasPressed(at indexPath: IndexPath){
        
        let notebookToBeRemoved = self.cells[indexPath.row].notebookModel()
        self.dataManager.viewContext.delete(notebookToBeRemoved)
        self.dataManager.saveContext()
        
    }
    
    /// Call this function to clear up. To erase all Notebooks on the Storage
    func removeAllButtonWasPressed(){
        self.dataManager.deleteAll(entityName: "Notebook")
        self.cells.removeAll()
        self.dataManager.saveContext()
    }
}

extension NotebookViewModel: NSFetchedResultsControllerDelegate {
    
    // will change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    // did change a section.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType){}
    
    // did change an object.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .insert:
                self.delegate?.dataDidChange(type: type, indexPath: newIndexPath!)
            case .delete:
                self.delegate?.dataDidChange(type: type, indexPath: indexPath!)
            case .update:
                self.delegate?.dataDidChange(type: type, indexPath: indexPath!)
            case .move:
                self.delegate?.dataDidChange(type: type, indexPath: newIndexPath!)
            @unknown default:
                fatalError()
        }
    }
    
    // did change content.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
}
