//
//  NoteViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class AddNoteViewController: UIViewController {

    // MARK: - Class Properties
    private let viewModel: AddNoteViewModel
    
    
    // MARK: - Outlets
    @IBOutlet weak var noteTitleTextField:      UITextField!
    @IBOutlet weak var noteContentTextField:    UITextField!
    @IBOutlet weak var collectionViewContainer: UIView!
    private var collectionView:                 UICollectionView!
    
    
    
    // MARK: - Lifecycle
    init(addNoteViewModel: AddNoteViewModel) {
        self.viewModel = addNoteViewModel
        super.init(nibName: "NoteViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        setupNavigationBarStyleAndItems()
        setupOutletStyleandItems()
    }
    
    // MARK: - Actions
    @objc private func didPressCancelButton(){
        self.viewModel.cancelButtonWasPressed()
    }
    
    @IBAction func didPressCreateButton(_ sender: UIButton) {
        
        if !noteTitleTextField.text!.isEmpty {
            let title = noteTitleTextField.text!
            let content = "note content"
            viewModel.createButtonWasPressed(title: title, content: content)
        }
    }
    
    @IBAction func didPressAddPhotoButton(_ sender: UIButton) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true

        
    }
    
    
    // MARK: - Class functionalities
    private func setupNavigationBarStyleAndItems(){
        
        self.title = "Notes"
        
        let backButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didPressCancelButton))
        navigationItem.leftBarButtonItem = backButtonItem
        
    }
    
    private func setupOutletStyleandItems(){
        self.collectionView = self.view.createCollectionView(delegate: self, dataSource: self, orientation: .vertical)
        self.collectionViewContainer.addSubview(collectionView)
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.pin(to: self.collectionViewContainer)
    }
}


// MARK: - Extension for UICollectionViewDataSource
extension AddNoteViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentView.backgroundColor = .systemBlue
        return cell
    }
}

// MARK: - Extension for UICollectionViewDelegate
extension AddNoteViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// MARK: - Extension for UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension AddNoteViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
    
}
