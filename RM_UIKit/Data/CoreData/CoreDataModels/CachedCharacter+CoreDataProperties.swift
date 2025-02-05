//
//  CachedCharacter+CoreDataProperties.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//
//

import Foundation
import CoreData


extension CachedCharacter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedCharacter> {
        return NSFetchRequest<CachedCharacter>(entityName: "CachedCharacter")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var species: String?
    @NSManaged public var gender: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var locationName: String?

}

extension CachedCharacter : Identifiable {

}
