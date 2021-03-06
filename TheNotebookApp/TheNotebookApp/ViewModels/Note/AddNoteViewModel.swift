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
            self.dataManager.addNoteImage(imageData: image, note: note) { (image) in}
            
        }else{
            self.itemViewModel.append(AddNoteCellItemViewModel(image: image))
            self.delegate?.didPhotoSourceChange()
        }
    
        
    }
    
    func saveButtonWasPressed(title: String, content: String){
        self.coordinatorDelegate?.didCreated()
        guard let belongsTo  = self.getParentNotebook() else { return }
        guard let actualMode = self.mode else { return }
        
        switch actualMode {
            case .edit:
                self.updateNote(newTitle: title, newContent: content)
            case .create:
                self.createNote(noteTitle: title, noteContent: content, belongsTo: belongsTo)
        }
      
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
      
        self.dataManager.addNote(title: noteTitle, description: noteContent, belongsTo: belongsTo) {[weak self] (note) in
            guard let self = self else { return }
            self.insertNotePhotos(note: note)
        }
        
        
    }
    
    private func insertNotePhotos(note: NoteMO){
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }
            
            if self.itemViewModel.count > 0 {
                for item in self.itemViewModel{
                    self.dataManager.addNoteImage(imageData: item.imageData, note: note) { (image) in
                        note.addToHasImages(image)
                        image.belongsTo = note
                    }
                    
                }
            }
            
            
        }
 
    }
}

extension AddNoteViewModel: NSFetchedResultsControllerDelegate {
    
    // will change
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>){
    }
    
    // did change a section.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType){}
    
    // did change an object.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.delegate?.didChangeObject(type: type, indexPath: indexPath ?? IndexPath(), newIndexPath: newIndexPath ?? IndexPath())
        
    }
    // did change content.
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
}

