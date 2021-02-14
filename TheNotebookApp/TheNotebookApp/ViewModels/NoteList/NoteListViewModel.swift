//
//  NoteViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation
import CoreData

class NoteListViewModel: NSObject{
    
    // MARK: - Class properties
    var title: String
    private var notesFetchResultsController:  NSFetchedResultsController<NSFetchRequestResult>?
    private var dataManager:    LocalDataManager
    var delegate:               NoteListViewModelDelegate?
    var coordinatorDelegate:    NoteListCoordinatorDelegate?
    var cells:                  [NoteListCellViewModel] = []
    private var notebook:       NotebookMO
    private var isRemovingAll = false
    
    
    // MARK: - Lifecycle
    init(notebook: NotebookMO, localDataManager: LocalDataManager) {
        self.notebook = notebook
        self.title = notebook.title!
        self.dataManager = localDataManager
        super.init()
    }
    
    // MARK: - Class functionalities
    //CoreData Related
    private func setupResultController(predicate: NSPredicate){
        
        // 2. Crear nuestro NSFetchRequest
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        
        // 3. Seteamos el NSSortDescriptor.
        let noteCreatedAtSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [noteCreatedAtSortDescriptor]
        
        // 4. Creamos nuestro NSPredicate.
        fetchRequest.predicate = predicate
        
        // 5. Creamos el NSFetchResultsController.
        notesFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: dataManager.viewContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        
        self.notesFetchResultsController?.delegate = self
        // 6. Perform fetch.
        do {
            try notesFetchResultsController?.performFetch()
        } catch {
            fatalError("couldn't find notes \(error.localizedDescription) ")
        }
        
    }
    
    
    //View Related
    func viewWasLoad(){
        let predicate = NSPredicate(format: "belongsTo == %@", self.notebook)
        setupResultController(predicate: predicate)
    }
    
    func cellWasLoad(at indexPath: IndexPath) -> NoteListCellViewModel? {
        guard let note = notesFetchResultsController?.object(at: indexPath) as? NoteMO else {
            fatalError("Attempt to configure cell without a managed object")
        }
        let noteCell = NoteListCellViewModel(noteMO: note)
        cells.append(noteCell)
        return noteCell
    }
    
    func numberOfRows(in section: Int) -> Int{
        if let fetchResultsController = notesFetchResultsController {
            return fetchResultsController.sections![section].numberOfObjects
        }
        return self.cells.count
    }
    
    func cellWasSelected(at indexPath: IndexPath){
        guard let note = notesFetchResultsController?.object(at: indexPath) as? NoteMO else {
            fatalError("Attempt to configure cell without a managed object")
        }
        self.coordinatorDelegate?.didSelectNote(note: note)
    }
    
    func searchForThisText(predicate: String){

        print(predicate)
        let predicate = NSPredicate(format: "title CONTAINS %@", predicate)
        setupResultController(predicate: predicate)
    }
    
    func plusButtonWasPressed(){
        self.coordinatorDelegate?.didPressPlusButton(belongsTo: self.notebook)
    }
    
    func deleteNoteWasPressed(at indexPath: IndexPath){
        let noteToBeRemoved = self.cells[indexPath.row].noteModel()
        dataManager.deleteNote(note: noteToBeRemoved)
        
    }
    
    func removeAllWasPressed(){
        self.isRemovingAll = true
        self.dataManager.deleteAll(entityName: "Note")
        self.dataManager.resetContext()
        cells.removeAll()
        print(cells.count)
    }

}


extension NoteListViewModel: NSFetchedResultsControllerDelegate {
    
    // will change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {

    }
    
    // did change a section.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType){}
    
    // did change an object.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//        self.delegate?.didChange()
        
        
        switch type {
            case .insert:
                self.delegate?.dataDidChange(type: type, indexPath: newIndexPath!, isRemovingAll: self.isRemovingAll)
            case .delete:
                self.delegate?.dataDidChange(type: type, indexPath: indexPath!, isRemovingAll: self.isRemovingAll)
            case .update:
                self.delegate?.dataDidChange(type: type, indexPath: indexPath!, isRemovingAll: self.isRemovingAll)
            case .move:
                self.delegate?.dataDidChange(type: type, indexPath: newIndexPath!, isRemovingAll: self.isRemovingAll)
            @unknown default:
                fatalError()
        }
        
        
    }
    
    // did change content.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
}
