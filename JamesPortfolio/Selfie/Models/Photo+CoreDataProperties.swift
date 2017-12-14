//
//  Photo+CoreDataProperties.swift
//  
//
//  Created by James Kim on 12/12/17.
//

import UIKit
import CoreData

public class Photo: NSManagedObject {
    
}

extension Photo {
    static var entityName: String {
        return String(describing: Photo.self)
    }
    
    @NSManaged public var imageData: NSData
    @NSManaged public var creationDate: NSDate
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        let request = NSFetchRequest<Photo>(entityName: "Photo")
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        return request
    }
    
    @nonobjc class func with(_ image: UIImage, in context: NSManagedObjectContext) -> Photo {
        let photo = NSEntityDescription.insertNewObject(forEntityName: Photo.entityName, into: context) as! Photo
        photo.creationDate = Date() as NSDate
        photo.imageData = UIImageJPEGRepresentation(image, 1.0)! as NSData
        return photo
    }
    
    
    
}


extension Photo {
    var image: UIImage {
        return UIImage(data: self.imageData as Data)!
    }
}
