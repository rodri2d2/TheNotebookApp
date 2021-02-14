//
//  NotebookCelsTableViewCell.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

class NotebookCell: UITableViewCell {

    // MARK: - Class Properties
    static let IDENTIFIER = "NotebookCell"
    var viewModel: NotebookCellViewModel?{
        didSet{
            guard let viewModel = viewModel else { return }
            noteboolTitle.text  = viewModel.title
            notebookDescription.text = viewModel.description
            let stringDate = dateFormatter.string(from: viewModel.createdAt)
            notebookCreatedDate.text = stringDate
            setupNotesLabel(numberOfNotes: viewModel.numberOfNotes)
            
        }
    }
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    // MARK: - Outlets
    @IBOutlet weak var noteboolTitle:       UILabel!
    @IBOutlet weak var notebookDescription: UILabel!
    @IBOutlet weak var notebookCreatedDate: UILabel!
    @IBOutlet weak var notesWordLabel: UILabel!
    @IBOutlet weak var numberOfNotesLabel: UILabel!
    @IBOutlet weak var supportView:         UIView!
    
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupOutletsStylesAndItems()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Class functionalities
    private func setupOutletsStylesAndItems(){
        supportView.layer.cornerRadius = 10
        supportView.layer.borderWidth  = 1
        supportView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    private func setupNotesLabel(numberOfNotes: Int){
        if numberOfNotes >= 1{
            numberOfNotesLabel.textColor = .systemOrange
            notesWordLabel.textColor = .systemOrange
            numberOfNotesLabel.text = String(numberOfNotes)
            notesWordLabel.text = "notes"
        }
    }
    
    override func prepareForReuse() {
        self.noteboolTitle.text       = nil
        self.notebookDescription.text = nil
        self.notebookCreatedDate.text = nil
        
        //
        self.numberOfNotesLabel.text  = "0"
        self.notesWordLabel.text      = "notes"
        numberOfNotesLabel.textColor = .systemGray
        notesWordLabel.textColor = .systemGray
    }
    
}
