//
//  CharacterDetailRepository.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 3/11/25.
//

import Foundation
import Combine

protocol CharacterDetailRepositoryProtocol {
    func getDetailCharacter(_ id: Int) -> AnyPublisher<Character, APIError>
    func getCachedDetailCharacter(for id: Int) -> AnyPublisher<Character?, CoreDataError>
}

class CharacterDetailRepository: CharacterDetailRepositoryProtocol {
    private let apiClient: APIServiceProtocol
    private let dbClient: DBServiceProtocol
    
    init(apiClient: APIServiceProtocol, dbClient: DBServiceProtocol) {
        self.apiClient = apiClient
        self.dbClient = dbClient
    }
    
    func getDetailCharacter(_ id: Int) -> AnyPublisher<Character, APIError> {
        return apiClient.getDetailCharacter(id)
    }
    
    func getCachedDetailCharacter(for id: Int) -> AnyPublisher<Character?, CoreDataError> {
        return dbClient.fetchDetailCharacter(id: id)
    }
}
