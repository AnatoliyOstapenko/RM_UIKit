//
//  CharacterListRepository.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 3/11/25.
//

import Foundation
import Combine

protocol CharacterListRepositoryProtocol {
    func getOnlineCharacters() -> AnyPublisher<CharacterListResponse, APIError>
    func getCachedCharacters() -> AnyPublisher<[Character], CoreDataError>
    func saveCharactersToCache(characters: [Character]) -> AnyPublisher<Void, CoreDataError>
}

class CharacterListRepository: CharacterListRepositoryProtocol {
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
