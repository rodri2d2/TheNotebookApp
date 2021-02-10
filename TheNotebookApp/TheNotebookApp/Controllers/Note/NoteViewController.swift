//
//  NoteViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class NoteViewController: UIViewController {

    // MARK: - Class Properties
    private let viewModel: AddNoteViewModel
    
    
    // MARK: - Lifecycle
    init(addNoteViewModel: AddNoteViewModel) {
        self.viewModel = addNoteViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupNavigationBarStyleAndItems()
    }
    
    
    // MARK: - Class functionalities
    private func setupNavigationBarStyleAndItems(){
        
        self.title = "Notes"
        
        let backButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancelButton))
        navigationItem.leftBarButtonItem = backButtonItem
        
        
    }
    
    // MARK: - Actions
    @objc private func didPressCancelButton(){
        self.viewModel.cancelButtonWasPressed()
    }
    
}
