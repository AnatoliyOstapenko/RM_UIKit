//
//  APIError.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 04.02.2025.
//

import Foundation

enum APIError: Error, LocalizedError {
    case offline
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .offline:
            return "No Internet connection, it is required to run the application for the first time"
        case .requestFailed(let error):
            return "An request error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "An decoding error occurred: \(error.localizedDescription)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        case .invalidURL, .invalidResponse:
            return "Something went wrong, try again later"
        }
    }
}
