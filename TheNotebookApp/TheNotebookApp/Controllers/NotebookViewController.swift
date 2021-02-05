//
//  NotebookViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class NotebookViewController: UIViewController{

    // MARK: - Class properties
    private var viewModel: NotebookViewModel
    
    // MARK: - Outlets
    var tablewView: UITableView?
    
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
        self.view.backgroundColor = .white
        //
        self.viewModel.delegate = self
        self.viewModel.viewWasLoad()
        //
        setupNavigationControllerStyleAndItems()
        //
        setupOutletsSytlesAndItems()
        
    }
    
    // MARK: - Actions
    @objc private func didPressPlusButton(){
        self.viewModel.plusButtonWasPressed()
    }
    
    @objc private func didPressRemoveAllButton(){
        self.viewModel.removeAllButtonWasPressed()
    }
    
    // MARK: - Class functionalities
    private func setupNavigationControllerStyleAndItems(){
        //
        self.title = viewModel.title
        //
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //
        setupLeftBarItem()
        setupRightBarItem()

    }
    
    private func setupRightBarItem(){
        //
        let plusButtonRightItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressPlusButton))
        self.navigationItem.rightBarButtonItem = plusButtonRightItem
        
    }
    
    private func setupLeftBarItem(){
        let clearAllLeftItem = UIBarButtonItem(title: "Remove All", style: .plain, target: self, action: #selector(didPressRemoveAllButton))
        self.navigationItem.leftBarButtonItem = clearAllLeftItem
    }
    
    private func setupOutletsSytlesAndItems(){
        self.tablewView = self.view.createTableView(delegate: self, dataSource: self)
        self.tablewView?.register(NotebookCell.self, forCellReuseIdentifier: NotebookCell.IDENTIFIER)
    }
    
}

// MARK: - Extension for NotebookViewModelDelegate
extension NotebookViewController: NotebookViewModelDelegate{
    
}


// MARK: - Extension for UITableViewDataSource
extension NotebookViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Add cell \(indexPath.row)"
        return cell
    }
}

// MARK: - Extension for UITableViewDelegate
extension NotebookViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

