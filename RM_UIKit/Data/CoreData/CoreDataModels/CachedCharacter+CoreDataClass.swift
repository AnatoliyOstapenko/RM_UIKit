//
//  CachedCharacter+CoreDataClass.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//
//

import Foundation
import CoreData

@objc(CachedCharacter)
public class CachedCharacter: NSManagedObject {

}

extension CachedCharacter {
    func toDomain() -> Character {
        return Character(
            id: Int(self.id),
            name: self.name ?? "Unknown",
            status: self.status ?? "Unknown",
            species: self.species ?? "Unknown",
            type: "",
            gender: self.gender ?? "Unknown",
            origin: Origin(name: "", url: ""),
            location: Location(name: self.locationName ?? "Unknown", url: ""),
            image: self.imageURL ?? "",
            episode: [],
            url: "",
            created: ""
        )
    }
}
