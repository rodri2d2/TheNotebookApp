//
//  NoteViewController.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController {
    
    // MARK: - Class Properties
    private let viewModel: AddNoteViewModel
    private var blockOperations: [BlockOperation] = []
    
    
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
    
    deinit {
        for operation in blockOperations { operation.cancel() }
        blockOperations.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let noteObject = viewModel.viewWasLoad()
        setupNavigationBarStyleAndItems()
        setupOutletStyleandItems(note: noteObject)
    }
    
    // MARK: - Actions
    @objc private func didPressCancelButton(){
        
        guard let barButton = navigationItem.leftBarButtonItem else {return}
        if let title = barButton.title{
         
            if title.elementsEqual("Done"){
                if !noteTitleTextField.text!.isEmpty {
                    let title = noteTitleTextField.text!
                    let content = noteContentTextField.text!
                    viewModel.saveButtonWasPressed(title: title, content: content)
                }
            }else if title.elementsEqual("Cancel") {
                self.viewModel.cancelButtonWasPressed()
            }
        }
        self.viewModel.cancelButtonWasPressed()
    }
    
    @objc func didPressCreateButton(_ sender: UIButton) {
        
        if !noteTitleTextField.text!.isEmpty {
            let title = noteTitleTextField.text!
            let content = noteContentTextField.text!
            viewModel.saveButtonWasPressed(title: title, content: content)
        }
    }
    
    @objc func didPressAddPhotoButton(_ sender: UIButton) {
        self.imagePicker.delegate = self
        self.showAlert()
        
    }
    
    
    // MARK: - Class functionalities
    private func setupNavigationBarStyleAndItems(){
        
        self.title = "Notes"
        setupLeftBarButton(with: "Cancel")
        setupRightBarButton()
    }
    
    private func setupLeftBarButton(with title: String){
        
        let leftButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(didPressCancelButton))
        navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    private func setupRightBarButton(){
        
        let image = UIImage(systemName: "camera.fill")
        let rightButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(didPressAddPhotoButton))
        navigationItem.rightBarButtonItem = rightButtonItem
        
    }
    
    
    private func setupOutletStyleandItems(note: NoteMO?){
        if let noteToEdit = note {
            noteTitleTextField.text = noteToEdit.title
            noteContentTextField.text = noteToEdit.noteContent
            setupLeftBarButton(with: "Done")
        }
        
        setupCollectionView()
        setupTexField()
    }
    
    private func setupCollectionView(){
        self.collectionView = self.view.createCollectionView(delegate: self, dataSource: self, orientation: .vertical)
        self.collectionViewContainer.addSubview(collectionView)
        self.collectionView.register(UINib(nibName: "NoteItemCell", bundle: .main), forCellWithReuseIdentifier: "cell")
        collectionView.pin(to: self.collectionViewContainer)
        collectionView.backgroundColor = .white
        
    }
    
    
    private func setupTexField(){
        self.noteTitleTextField.delegate = self
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
extension AddNoteViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
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

extension AddNoteViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setupLeftBarButton(with: "Done")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if (textField.text!.isEmpty){
            self.setupLeftBarButton(with: "Cancel")
        }
    }
    
}


extension AddNoteViewController: AddNoteViewModelDelegate{
    
    func didPhotoSourceChange() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func didChangeObject(type: NSFetchedResultsChangeType, indexPath: IndexPath, newIndexPath: IndexPath?) {
        
        collectionView?.performBatchUpdates({ () -> Void in
            for operation: BlockOperation in self.blockOperations {
                switch type {
                    case .insert:
                        blockOperations.append(
                            BlockOperation(block: { [weak self] in
                                guard let self = self else { return }
                                self.collectionView.insertItems(at: [indexPath])
                            })
                        )
                        
                    case .delete:
                        blockOperations.append(
                            BlockOperation(block: { [weak self] in
                                guard let self = self else { return }
                                self.collectionView.deleteItems(at: [indexPath])
                            })
                        )
                        
                    case .move:
                        blockOperations.append(
                            BlockOperation(block: { [weak self] in
                                guard let self = self else { return }
                                guard let index = newIndexPath else {return}
                                self.collectionView.moveItem(at: indexPath, to: index)
                            })
                        )
                    case .update:
                        blockOperations.append(
                            BlockOperation(block: { [weak self] in
                                guard let self = self else { return }
                                self.collectionView.reloadItems(at: [indexPath])
                            })
                        )
                        
                    @unknown default:
                        fatalError()
                }
                operation.start()
            }
        }, completion: { (finished) -> Void in
            self.blockOperations.removeAll(keepingCapacity: false)
        })
        
    }
    
    
    func didChangeContent(controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
}
