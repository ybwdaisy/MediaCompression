//
//  Settings.swift
//  MediaCompression
//
//  Created by ybw-macbook-pro on 2022/12/17.
//

import Foundation
import CoreData

final class Settings: NSManagedObject {
    @NSManaged var imageCompressionQuality: Float
    
    @NSManaged var imageKeepCreationDate: Bool
    
    @NSManaged var videoCompressionQuality: String
    
    @NSManaged var videoKeepCreationDate: Bool
    
    @NSManaged var audioAutoSave: Bool
    
    @NSManaged var audioAllowsMultiple: Bool
}
