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
    private var tablewView: UITableView!
    
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
        
        self.viewModel.viewWasLoad()
        //
        setupNavigationBarStyleAndItems()
        setupOutletsStyleAndItems()
    }
    
    // MARK: - Actions
    @objc private func didPressPlusButton(){
        self.viewModel.plusButtonWasPressed()
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
        self.tablewView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tablewView)
        self.tablewView.pin(to: self.view)        
    }
}


// MARK: - Extension for UITableViewDataSource
extension NoteListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellViewModel = self.viewModel.cellWasLoad(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = cellViewModel?.noteTitle
        cell.detailTextLabel?.text = cellViewModel?.noteContent
        return cell
    }
}

// MARK: - Extension for UITableViewDelegate
extension NoteListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.cellWasSelected(at: indexPath)
    }
}


extension NoteListViewController: NoteListViewModelDelegate{
    func didChange() {
        self.tablewView.reloadData()
    }
}
