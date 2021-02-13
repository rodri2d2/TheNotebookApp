//
//  NoteListViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class NoteListViewController: UIViewController {
    
    // MARK: - Class properties
    private let viewModel:        NoteListViewModel
    
    // MARK: - Outlets
    private var tablewView: UITableView!
    private var searchBar = UISearchBar()
    
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
    
    @objc private func didStartSearching(){
        setupSearchBarShow(isShowing: true)
        self.searchBar.becomeFirstResponder()
    }
    
    // MARK: - Class functionalities
    private func setupNavigationBarStyleAndItems(){
        
        self.title = viewModel.title
        self.navigationController?.navigationBar.prefersLargeTitles = true
  
        //
        setupRightBarStyleAndItems()
        setupSearchBar()
    }
    
    private func setupSearchBar(){
        self.searchBar.sizeToFit()
        self.searchBar.delegate          = self
        self.searchBar.showsCancelButton = true
    }
    
    
    private func setupSearchBarShow(isShowing: Bool){
        
        if isShowing{
            self.navigationItem.rightBarButtonItems = nil

        }else{
            self.setupRightBarStyleAndItems()
        }
        
        self.navigationItem.titleView = isShowing ? self.searchBar : nil
        self.navigationItem.setHidesBackButton(isShowing, animated: true)
        
    }

    private func setupRightBarStyleAndItems(){
       
        //Add note button
        let addNoteImage = UIImage(systemName: "pencil.tip.crop.circle.badge.plus")
        let plusButtonRightItem = UIBarButtonItem(image: addNoteImage, style: .plain, target: self, action: #selector(didPressPlusButton))
        
        //Remove all button
        let clearAllLeftItem = UIBarButtonItem(title: "Remove All", style: .plain, target: self, action: #selector(didPressRemoveAllButton))
        
        //Search button
        let searchImage = UIImage(systemName: "magnifyingglass.circle")
        let searchButtonRightItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(didStartSearching))
        
        //Install buttons
        self.navigationItem.rightBarButtonItems = [plusButtonRightItem, searchButtonRightItem, clearAllLeftItem]
        
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

// MARK: - Extension for UISearchBarDelegate
extension NoteListViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            self.viewModel.searchForThisText(predicate: searchBar.text!)
            self.tablewView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.setupSearchBarShow(isShowing: false)
        self.viewModel.viewWasLoad()
        self.tablewView.reloadData()
    }
}

// MARK: - Extension for NoteListViewModelDelegate
extension NoteListViewController: NoteListViewModelDelegate{
    func didChange() {
        self.tablewView.reloadData()
    }
}
