//
//  CoreDataError.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import Foundation

enum CoreDataError: Error, LocalizedError {
    case failedToSave(Error)
    case fetchFailed(Error)
    case deletionFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .failedToSave(let error):
            return "Failed to save error occurred: \(error.localizedDescription)"
        case .fetchFailed(let error):
            return "Failed to fetch error occurred: \(error.localizedDescription)"
        case .deletionFailed(let error):
            return "Failed to delete error occurred: \(error.localizedDescription)"
        }
    }
}
