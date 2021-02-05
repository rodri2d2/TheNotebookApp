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
        setupNavigationControllerStyleAndItems()
        //
        setupOutletsSytlesAndItems()
        
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
        
        
        alert.addAction(UIAlertAction(title: "Create Notebook", style: .cancel, handler: {[weak self]  _ in
        
            guard let titleField = alert.textFields?[0],
                  let descField = alert.textFields?[1],
                  let title = titleField.text,
                  let description = descField.text
            else{return}
            
            if !title.isEmpty{
                print(title)
                self?.viewModel.plusButtonWasPressed(title: title, description: description)
            }
        }))
        
        present(alert, animated: true, completion: nil)

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
        self.tablewView.register(UINib(nibName: NotebookCell.IDENTIFIER, bundle: .main), forCellReuseIdentifier: NotebookCell.IDENTIFIER)
        self.view.addSubview(self.tablewView)
        self.tablewView.pin(to: self.view)
        tablewView.separatorStyle = .none
    }
    
}

// MARK: - Extension for NotebookViewModelDelegate
extension NotebookViewController: NotebookViewModelDelegate{
    func dataDidChange() {
        self.tablewView.reloadData()
    }
    
    
}

// MARK: - Extension for UITableViewDataSource
extension NotebookViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfNotebooks()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellViewModel = self.viewModel.cellWasLoad(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(withIdentifier: NotebookCell.IDENTIFIER, for: indexPath) as! NotebookCell
        cell.viewModel = cellViewModel
        return cell
    }
}

// MARK: - Extension for UITableViewDelegate
extension NotebookViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
    
}

