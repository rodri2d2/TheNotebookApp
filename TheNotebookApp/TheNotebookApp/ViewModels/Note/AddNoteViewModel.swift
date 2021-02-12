//
//  NoteViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation
import CoreData

class AddNoteViewModel: NSObject {
    
    // MARK: - Class properties
    var delegate:            AddNoteViewModelDelegate?
    var coordinatorDelegate: AddNoteCoodinatorDelegate?
    private var imageFetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    private let dataManager: LocalDataManager
    private let notebook: NotebookMO
    private var note:     NoteMO?
    private var itemViewModel: [AddNoteCellItemViewModel] = []
    
    // MARK: - Lifecycle
    init(localDataManager: LocalDataManager, notebook: NotebookMO) {
        self.dataManager = localDataManager
        self.notebook = notebook
        super.init()
    }
    
    // MARK: - Class functionalities
    private func setupResultsController(){
        
        // 2. Crear nuestro NSFetchRequest
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        
        // 3. Seteamos el NSSortDescriptor.
        let noteCreatedAtSortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [noteCreatedAtSortDescriptor]
        
        // 4. Creamos nuestro NSPredicate.
        guard let note = self.note else { return  }
        fetchRequest.predicate = NSPredicate(format: "belongsTo == %@", note)
        
        // 5. Creamos el NSFetchResultsController.
        imageFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                 managedObjectContext: dataManager.viewContext,
                                                                 sectionNameKeyPath: nil,
                                                                 cacheName: nil)
        
        imageFetchResultsController?.delegate = self
        // 6. Perform fetch.
        do {
            try imageFetchResultsController?.performFetch()
        } catch {
            fatalError("couldn't find notes \(error.localizedDescription) ")
        }
    }
    
    func viewWasLoad(){
        setupResultsController()
    }

    func cellWasLoad(at indexPath: IndexPath) -> AddNoteCellItemViewModel{
        if let image = imageFetchResultsController?.object(at: indexPath) as? ImageMO {
            if let imageFromCoreData = image.imageData {
                let imageItem = AddNoteCellItemViewModel(image: imageFromCoreData)
                itemViewModel.append(imageItem)
                return imageItem
            }
        }
        
        return itemViewModel[indexPath.row]
    }
    
    
    func numberOfItems(section: Int) -> Int{
        if let fetchResultsController = imageFetchResultsController {
            return fetchResultsController.sections![section].numberOfObjects
        }
        return itemViewModel.count
    }
    
    func imageWasSelected(image: Data){
        self.itemViewModel.append(AddNoteCellItemViewModel(image: image))
        self.delegate?.didChange()
    }
    
    func createButtonWasPressed(title: String, content: String){
        
        
        guard let note = NoteMO.createNote(title: title, content: content, belongsTo: self.notebook, in: dataManager.viewContext) else {return}
        
        if itemViewModel.count > 0 {
            for item in itemViewModel{
                guard let noteImage = ImageMO.createImage(imageData: item.imageData, belongsTo: note, context: dataManager.viewContext) else {return}
                note.addToHasImages(noteImage)
            }
        }
        
        self.coordinatorDelegate?.didCreated()
    }
    
    func cancelButtonWasPressed(){
        self.coordinatorDelegate?.didCancel()
    }
    
    
    
}

extension AddNoteViewModel: NSFetchedResultsControllerDelegate {
    
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
        self.delegate?.didChange()
        
    }
    
    // did change content.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        print("did change content.")
    }
    
}

