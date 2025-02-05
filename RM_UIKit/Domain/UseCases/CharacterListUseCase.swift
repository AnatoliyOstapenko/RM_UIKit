//
//  CharacterListUseCase.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import Combine

protocol CharacterListUseCaseProtocol {
    func getOnlineCharacters() -> AnyPublisher<CharacterListResponse, APIError>
    func getCachedCharacters() -> AnyPublisher<[Character], CoreDataError>
}

class CharacterListUseCase: CharacterListUseCaseProtocol {
    private let apiClient: APIServiceProtocol
    private let dbClient: DBServiceProtocol
    
    init(apiClient: APIServiceProtocol, dbClient: DBServiceProtocol) {
        self.apiClient = apiClient
        self.dbClient = dbClient
    }

    func getOnlineCharacters() -> AnyPublisher<CharacterListResponse, APIError> {
        return apiClient.getCharacters()
    }

    func getCachedCharacters() -> AnyPublisher<[Character], CoreDataError> {
        return dbClient.fetchAllCharacters()
    }
    
    func saveCharactersToCache(characters: [Character]) -> AnyPublisher<Void, CoreDataError> {
        // Delete previous characters and save a new characters
        return dbClient.deleteAllCharacters()
            .flatMap { _ in
                Publishers.MergeMany(characters.map { self.dbClient.saveCharacter($0) })
                    .collect()
                    .map { _ in () }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
