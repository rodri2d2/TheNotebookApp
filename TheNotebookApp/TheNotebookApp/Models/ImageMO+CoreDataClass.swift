//
//  ImageMO+CoreDataClass.swift
//  TheNotebookApp
//
//  Created by Rodrigo Candido on 11/2/21.
//
//

import Foundation
import CoreData


public class ImageMO: NSManagedObject {
    
    static func createImage(imageData: Data, belongsTo: NoteMO?, context: NSManagedObjectContext) -> ImageMO?{
        let image = NSEntityDescription.insertNewObject(forEntityName: "Image", into: context) as? ImageMO
        
        image?.createdAt = Date() 
        image?.imageData = imageData
        
        if let note = belongsTo{
            image?.belongsTo = note
        }
   
        
        return image
    }
    
}
