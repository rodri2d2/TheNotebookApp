//
//  NotebookViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class NotebookViewController: UIViewController {

    // MARK: - Class properties
    private var viewModel: NotebookViewModel
    
    // MARK: - Lyfecycle
    init(notebookViewModel: NotebookViewModel) {
        self.viewModel = notebookViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
    }

}
