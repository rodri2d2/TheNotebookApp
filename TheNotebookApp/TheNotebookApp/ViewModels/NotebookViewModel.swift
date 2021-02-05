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
      
        let notebooksMock = NotebookMockData.notebooks()
        cells = notebooksMock.map({ notebookDataMock in
            return NotebookCellViewModel(notebookItem: notebookDataMock)
        })
        
    }
    
    func cellWasLoad() -> NotebookCellViewModel? {
        return nil
    }
    
    func numberOfNotebooks() -> Int{
        return self.cells.count
    }
    
    //Actions Related
    func plusButtonWasPressed(){
        self.coordinatorDelegate?.didPressPlusButton()
    }
    
    func removeAllButtonWasPressed(){
        print("Remove all notebooks")
    }
    
}
