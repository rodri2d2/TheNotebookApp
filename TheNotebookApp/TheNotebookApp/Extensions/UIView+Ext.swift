//
//  UIView+Ext.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import UIKit

/*
 This extension implements custom functionalities to UIView Class
 */
extension UIView {
    
    /**
     PIN a view to its super - Use this function to pin a view when this ocupies the entire Screen space of its super
     - Parameter superView: Its main or super container view to be pinned in
     
     ## Example
     
     Being at some ViewController or a Class that has a implementation of UIView, send this view property as parameter
     ~~~
     class ViewController: UIViewController {
     override func viewDidLoad() {
     super.viewDidLoad()
     tableView.pin(to: self.view)
     }
     }
     ~~~
     
     - Author: Rodrigo Candido
     - Version: v1.0
     
     */
    func pin(to superView: UIView){
        
        if let _ = superview {
            translatesAutoresizingMaskIntoConstraints                                  = false
            topAnchor.constraint      (equalTo:      superview!.topAnchor  ).isActive  = true
            leadingAnchor.constraint  (equalTo:  superview!.leadingAnchor  ).isActive  = true
            trailingAnchor.constraint (equalTo: superview!.trailingAnchor  ).isActive  = true
            bottomAnchor.constraint   (equalTo:   superview!.bottomAnchor  ).isActive  = true
        }
    }
    
    
    
    /**
     CreateTableView - Use this function create a UITableView with delegate and data source
     - Parameters:
        - delegate: type of class tha implemente UITableViewDelegate
        - dataSpurce: type of class tha implemente UITableViewDataSource
     
     ## Example
     
     Being at some ViewController or a Class that has a implementation of UIView, make it conforms to UITableViewDelegate and UITableViewDataSource and pass self in both parameters
     ~~~
     class ViewController: UIViewController {
     override func viewDidLoad() {
     super.viewDidLoad()
        let tableView = self.view.createTableView(delegate: self, dataSource: self)
     }
     }
     ~~~
     */
    func createTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) -> UITableView{
        let tableView = UITableView()
        tableView.delegate   = delegate
        tableView.dataSource = dataSource
        return tableView
    }
}
