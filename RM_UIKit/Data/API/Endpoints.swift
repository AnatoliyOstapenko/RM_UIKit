//
//  Endpoints.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 04.02.2025.
//

import Foundation

public struct Endpoints {
    static private var baseURL: String {
        return WebUrl.prodUrl
    }
    
    static var characterURL: String {
        return baseURL + "/api/character"
    }
}
