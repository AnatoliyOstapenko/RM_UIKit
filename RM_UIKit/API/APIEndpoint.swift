//
//  APIEndpoint.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 04.02.2025.
//

import Foundation

enum APIEndpoint {
    case getCharacters
    case getDetailCharacter(id: Int)
    
    var url: String {
        switch self {
        case .getCharacters:
            return Endpoints.characterURL
        case .getDetailCharacter(let id):
            return Endpoints.characterURL + "/\(id)"
        }
    }
