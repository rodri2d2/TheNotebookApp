//
//  NotebookViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit
import CoreData

class NotebookListViewController: UIViewController{
    
    // MARK: - Class properties
    private var viewModel: NotebookViewModel
    
    // MARK: - Outlets
    var tablewView: UITableView!
    
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
        setupNavigationBarStyleAndItems()
        //
        setupOutletsSytlesAndItems()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tablewView.reloadData()
    }
    
    // MARK: - Actions
    @objc private func didPressPlusButton(){
        
        
        let alert = UIAlertController(title: "New Notebook", message: "Enter New Notebook Info", preferredStyle: .alert)
        
        //Text field for notebook name
        alert.addTextField(configurationHandler: nil)
        alert.textFields![0].placeholder = "Enter Notebook Name"
        
        //Text field for notebook description
        alert.addTextField(configurationHandler: nil)
        alert.textFields![1].placeholder = "Enter Notebook Description"
        
        
        alert.addAction(UIAlertAction(title: "Create Notebook", style: .default, handler: {[weak self]  _ in
            
            guard let titleField = alert.textFields?[0],
                  let descField = alert.textFields?[1],
                  let title = titleField.text,
                  let description = descField.text
            else{return}
            
            if !title.isEmpty{
                self?.viewModel.plusButtonWasPressed(title: title, description: description)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func didPressRemoveAllButton(){
        
        
        let alert = UIAlertController(title: "DELETING...", message: "All Notebooks will be delete!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.removeAllButtonWasPressed()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Class functionalities
    private func setupNavigationBarStyleAndItems(){
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
        self.tablewView.register(UINib(nibName: NotebookCell.IDENTIFIER, bundle: .main), forCellReuseIdentifier: NotebookCell.IDENTIFIER)
        self.view.addSubview(self.tablewView)
        self.tablewView.pin(to: self.view)
        tablewView.separatorStyle = .none
    }
    
    
    private func editAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Edit") { [weak self ](action, view, completion) in
            guard let self = self else { return }
           
            let cellViewModel = self.viewModel.cellWasLoad(at: indexPath)
            let notebook = cellViewModel?.notebookModel()
        
            
            
            let alert = UIAlertController(title: "Edit Notebook", message: "Editing Notebook", preferredStyle: .alert)
            
            //Text field for notebook name
            alert.addTextField(configurationHandler: nil)
            alert.textFields![0].text = notebook?.title
            
            //Text field for notebook description
            alert.addTextField(configurationHandler: nil)
            alert.textFields![1].text = notebook?.notebookDesc
            
            
            alert.addAction(UIAlertAction(title: "Update Notebook", style: .default, handler: {  _ in
                
                guard let titleField = alert.textFields?[0],
                      let descField = alert.textFields?[1],
                      let title = titleField.text,
                      let description = descField.text
                else{return}
                
                if !title.isEmpty{
                    self.viewModel.updaButtonWasPressed(title: title, description: description, at: indexPath)
                }
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            
            
        }
        action.backgroundColor = .systemBlue
        action.image = UIImage(systemName: "pencil")
        return action
    }
    
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self ](action, view, completion) in
            guard let self = self else { return }
            self.viewModel.deleteNotebookWasPressed(at: indexPath)
            completion(true)
        }
    
        action.image = UIImage(systemName: "trash")
        return action
    }
    
}


// MARK: - Extension for UITableViewDataSource
extension NotebookListViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = self.viewModel.cellWasLoad(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NotebookCell.IDENTIFIER, for: indexPath) as! NotebookCell
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - Extension for UITableViewDelegate
extension NotebookListViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.viewModel.cellWasSelected(at: indexPath)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            let alert = UIAlertController(title: "DELETING...", message: "Notebook will be deleted!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: {[weak self]  _ in
                self?.viewModel.deleteNotebookWasPressed(at: indexPath)
                
            }))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [deleteAction])
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction   = self.editAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    
}

// MARK: - Extension for NotebookViewModelDelegate
extension NotebookListViewController: NotebookViewModelDelegate{
    
    
    
    func dataDidChange(type: NSFetchedResultsChangeType, indexPath: IndexPath, isRemovingAll: Bool) {
        
        if isRemovingAll{
            tablewView.reloadData()
        }else{
        
        self.tablewView.beginUpdates()
        switch type {
            case .insert:
                tablewView.insertRows(at: [indexPath], with: .fade)
            case .delete:
                tablewView.deleteRows(at: [indexPath], with: .fade)
            case .move:
                tablewView.moveRow(at: indexPath, to: indexPath)
            case .update:
                tablewView.reloadRows(at: [indexPath], with: .fade)
            @unknown default:
                fatalError()
        }
        self.tablewView.endUpdates()
        }
    }
    
    func didChange() {
        tablewView.reloadData()
    }

}






