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
    var delegate:                            AddNoteViewModelDelegate?
    var coordinatorDelegate:                 AddNoteCoodinatorDelegate?
    private let dataManager:                 LocalDataManager
    private var notebook:                    NotebookMO?
    private var note:                        NoteMO?
    private var itemViewModel:               [AddNoteCellItemViewModel] = []
    private var mode:                        Modes?
    private var imageFetchResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    // MARK: - Lifecycle
    init(localDataManager: LocalDataManager) {
        self.dataManager = localDataManager
        super.init()
    }
    
    // MARK: - Class functionalities
    func addNotebook(notebook: NotebookMO){
        self.notebook = notebook
    }
    
    func addNote(note: NoteMO){
        self.note = note
    }
    
    func setMode(mode: Modes){
        self.mode = mode
    }
    
    private func getParentNotebook() -> NotebookMO? {
        if self.notebook != nil {
            return self.notebook
        }else {
            return self.note?.belongsTo
        }
    }
    
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
        imageFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataManager.viewContext,
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
    
    func viewWasLoad() -> NoteMO? {
        //Aqui estoy editando la nota
        if self.note != nil {
            setupResultsController()
            return self.note
        }
        return nil
    }

    func cellWasLoad(at indexPath: IndexPath) -> AddNoteCellItemViewModel{
        
        if let image = imageFetchResultsController?.object(at: indexPath) as? ImageMO {
            if let imageFromCoreData = image.imageData {
                let imageItem = AddNoteCellItemViewModel(image: imageFromCoreData)
                return imageItem
            }
        }
        
        return itemViewModel[indexPath.row]
    }
    
    func numberOfItems(section: Int) -> Int{
        
        if let fetchResultsController = imageFetchResultsController {
            if fetchResultsController.sections![section].numberOfObjects > itemViewModel.count {
                return fetchResultsController.sections![section].numberOfObjects
            }
        }
        return itemViewModel.count
    }
    
    func imageWasSelected(image: Data){
        
        if self.note != nil{
            guard let note = self.note else { return }
            let _ = ImageMO.createImage(imageData: image, belongsTo: note, context: self.dataManager.viewContext)
        }else{
            self.itemViewModel.append(AddNoteCellItemViewModel(image: image))
        }
    
        self.delegate?.didChange()
    }
    
    func saveButtonWasPressed(title: String, content: String){
        guard let belongsTo  = self.getParentNotebook() else { return }
        guard let actualMode = self.mode else { return }
        
        switch actualMode {
            case .edit:
                self.updateNote(newTitle: title, newContent: content)
            case .create:
                self.createNote(noteTitle: title, noteContent: content, belongsTo: belongsTo)
        }
        self.coordinatorDelegate?.didCreated()
    }
    
    func cancelButtonWasPressed(){
        self.coordinatorDelegate?.didCancel()
    }
    
    private func updateNote(newTitle: String, newContent: String){
        if self.note != nil{
            self.note?.title       = newTitle
            self.note?.noteContent = newContent
            self.insertNotePhotos(note: self.note!)
        }
    }
    
    private func createNote(noteTitle: String, noteContent: String, belongsTo: NotebookMO){
        guard let note = NoteMO.createNote(title: noteTitle, content: noteContent, belongsTo: belongsTo, in: dataManager.viewContext) else {return}
        self.insertNotePhotos(note: note)
    }
    
    private func insertNotePhotos(note: NoteMO){
        if itemViewModel.count > 0 {
            for item in itemViewModel{
                guard let noteImage = ImageMO.createImage(imageData: item.imageData, belongsTo: note, context: dataManager.viewContext) else {return}
                note.addToHasImages(noteImage)
            }
        }
    }
    
    
}

extension AddNoteViewModel: NSFetchedResultsControllerDelegate {
    
    // will change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
    // did change a section.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType){}
    
    // did change an object.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.delegate?.didChange()
    }
    
    // did change content.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {}
    
}

