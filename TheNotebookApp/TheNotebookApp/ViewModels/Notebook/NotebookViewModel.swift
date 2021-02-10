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
            print("Error while trying to perform a notebook fetch.")
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
        let notebook = cells[indexPath.row].notebookModel()
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
        self.delegate?.dataDidChange()
        
    }
    
    
    /// Call this function to clear up. To erase all Notebooks on the Storage
    func removeAllButtonWasPressed(){
        cells.removeAll()
        delegate?.dataDidChange()
    }
}

extension NotebookViewModel: NSFetchedResultsControllerDelegate {
    
    // will change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("Will Change")
    }
    
    // did change a section.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType){
        print("did change a section")
    }
    
    // did change an object.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        print("did change an object")
        self.delegate?.dataDidChange()
        
    }
    
    // did change content.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("did change content.")
    }
    
}
