//
//  Environment.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 04.02.2025.
//

import Foundation

public enum Environment {
    enum Keys {
        static let baseUrl = "BASE_URL"
        static let dbModel = "CharacterDataModel"
    }

    // Accessing Info.plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // Fetching `baseUrl` from Info.plist
    static let baseUrl: String = {
        guard let baseUrlString = Environment.infoDictionary[Keys.baseUrl] as? String else {
            fatalError("Failed to get Base URL from plist")
        }
        return baseUrlString
    }()
    
    static var dbModel: String { Keys.dbModel }
}

// MARK: Constants
public enum Constants {
    static var errorTitle: String { "Error" }
    static var emptyState: String { "List of characters is empty" }
}
