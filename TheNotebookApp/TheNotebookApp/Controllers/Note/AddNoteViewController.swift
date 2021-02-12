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
    private lazy var imagePicker =              UIImagePickerController()
    
    
    
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
        viewModel.viewWasLoad()
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
        self.imagePicker.delegate = self
        self.showAlert()
        
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
        self.collectionView.register(UINib(nibName: "NoteItemCell", bundle: .main), forCellWithReuseIdentifier: "cell")
        collectionView.pin(to: self.collectionViewContainer)
        collectionView.backgroundColor = .white
    }
    
    private func showAlert(){
        //
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //
        if let libraryAction = self.imagePickerAlertActions(for: .photoLibrary, title:  "Photo Library"){
            alertController.addAction(libraryAction)
        }
        //
        if let cameraAction = self.imagePickerAlertActions(for: .camera, title: "Camera"){
            alertController.addAction(cameraAction)
        }
        //
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        //
        present(alertController, animated: true, completion: nil)
    }
    
    
    private func imagePickerAlertActions(for type: UIImagePickerController.SourceType, title: String)-> UIAlertAction?{
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.imagePicker.sourceType = type
            self.present(self.imagePicker, animated: true)
        }
    }
    
}


// MARK: - Extension for UICollectionViewDataSource
extension AddNoteViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! NoteItemCell
        let cellItem = viewModel.cellWasLoad(at: indexPath)
        
        cell.imageView.image = UIImage(data: cellItem.imageData)
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
        picker.dismiss(animated: true) {
            if let selectedImage = info[.originalImage] as? UIImage{
                guard let imageData = selectedImage.pngData() else { return }
                self.viewModel.imageWasSelected(image: imageData)
            }
        }
    }
    
}


extension AddNoteViewController: AddNoteViewModelDelegate{
    func didChange() {
        self.collectionView.reloadData()
    }
}
