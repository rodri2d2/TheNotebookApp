//
//  NoteViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class NoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupNavigationBarStyleAndItems()
    }
    
    
    private func setupNavigationBarStyleAndItems(){
        
        self.title = "Notes"
        
        let backButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancelButton))
        navigationItem.leftBarButtonItem = backButtonItem
        
        
    }
    
    // MARK: - Actions
    @objc private func didPressCancelButton(){
        
    }
    
}
