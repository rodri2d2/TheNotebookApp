//
//  Coordinator.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 5/2/21.
//

import Foundation


/**
 Coordinator Pattern based protocol
 
 Use this protocol to implement a navigation flow based on **Coordinator Pattern**
 
 */
protocol Coordinator: class {
    
    
    /// All class that conforms this protocol and has a Coordinator flow
    /// Master coordinator must keep a reference of its childrem
    var childrem: [Coordinator] { get set }
    
    
    /// Start method should be called whenever the entire configuration have finished on parent class
    /// This method will setup and for most casea deploy a navigation flow
    func start()
    
    
    /// Use this to finish a navigation flow for self or for child
    func finish()
    
}
