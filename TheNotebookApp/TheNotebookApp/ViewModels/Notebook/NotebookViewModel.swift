//
//  NotebookViewModel.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation


class NotebookViewModel{
    
    // MARK: - Class properties
    var coordinatorDelegate: NotebookCoodinatorDelegate?
    var delegate:            NotebookViewModelDelegate?
    private var cells:       [NotebookCellViewModel] = []
    let title = "Notebooks"
    
    // MARK: - Class functionalities
    //View Related
    func viewWasLoad(){
        //Do some DB load
    }
    
    func numberOfNotebooks() -> Int{
        return self.cells.count
    }
    
    func cellWasLoad(at indexRow: Int) -> NotebookCellViewModel {
        return cells[indexRow]
    }
    
    func cellWasSelected(at indexPath: IndexPath){
        
        let notebook = cells[indexPath.row].notebookModel()
        self.coordinatorDelegate?.didSelectANotebook(noteBook: notebook)
    }

    //Actions Related
    func plusButtonWasPressed(title: String, description: String){
        
        let notebookMockData = NotebookMockModel(title: title, decription: description, createdAt: Date(), notas: nil)
        cells.append(NotebookCellViewModel(notebookItem: notebookMockData))
        self.delegate?.dataDidChange()
        
    }
    
    func removeAllButtonWasPressed(){
        cells.removeAll()
        delegate?.dataDidChange()
    }
    
}
