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
        
//
////        supportView.layer.shadowColor = UIColor.gray.cgColor
//        supportView.layer.shadowOffset = CGSize.zero
//        supportView.layer.shadowOpacity = 0.2
//        supportView.layer.shadowRadius = 1
    }
    
}
