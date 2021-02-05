//
//  NoteListViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class NoteListViewController: UIViewController {

    // MARK: - Class properties
    private let viewModel: NoteListViewModel
    
    // MARK: - Outlets
    var tablewView: UITableView!
    
    // MARK: - Lyfecycle
    init(noteViewModel: NoteListViewModel) {
        self.viewModel = noteViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        setupNavigationBarStyleAndItems()
        setupOutletsStyleAndItems()
    }
    
    // MARK: - Actions
    @objc private func didPressPlusButton(){
        
    }
    
    @objc private func didPressRemoveAllButton(){
        
    }
    
    
    // MARK: - Class functionalities
    private func setupNavigationBarStyleAndItems(){
        //
        self.title = viewModel.title
        //
        self.navigationController?.navigationBar.prefersLargeTitles = true
        //
//        setupLeftBarItem()
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
    
    private func setupOutletsStyleAndItems(){
        self.tablewView = self.view.createTableView(delegate: self, dataSource: self)
//        self.tablewView.register(UINib(nibName: NotebookCell.IDENTIFIER, bundle: .main), forCellReuseIdentifier: NotebookCell.IDENTIFIER)
        self.view.addSubview(self.tablewView)
        self.tablewView.pin(to: self.view)
//        tablewView.separatorStyle = .none
        
    }
}


// MARK: - Extension for UITableViewDataSource
extension NoteListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Cell \(indexPath.row)"
        return cell
    }
}

// MARK: - Extension for UITableViewDelegate
extension NoteListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension NoteListViewController: NoteListViewModelDelegate{}
