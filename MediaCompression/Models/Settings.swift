//
//  Settings.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/12/17.
//

import Foundation
import CoreData

final class Settings: NSManagedObject {
    @NSManaged override var objectID: NSManagedObjectID
    
    @NSManaged var imageCompressionQuality: Float
    
    @NSManaged var imageKeepCreationDate: Bool
    
    @NSManaged var videoCompressionQuality: String
    
    @NSManaged var videoKeepCreationDate: Bool
    
    @NSManaged var videoSelectionLimit: Int
    
    @NSManaged var audioAutoSave: Bool
    
    @NSManaged var audioAllowsMultiple: Bool
}
