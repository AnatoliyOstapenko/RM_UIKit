//
//  CharacterDetailUseCase.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import Combine

protocol CharacterDetailUseCaseProtocol {
    func getDetailCharacter(_ id: Int) -> AnyPublisher<Character, APIError>
    func getCachedDetailCharacter(for id: Int) -> AnyPublisher<Character?, CoreDataError>
}

class CharacterDetailUseCase: CharacterDetailUseCaseProtocol {
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
