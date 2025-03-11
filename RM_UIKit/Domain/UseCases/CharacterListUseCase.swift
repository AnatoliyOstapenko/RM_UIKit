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
    func saveCharactersToCache(characters: [Character]) -> AnyPublisher<Void, CoreDataError>
}

class CharacterListUseCase: CharacterListUseCaseProtocol {
    private let repository: CharacterListRepositoryProtocol
    
    init(repository: CharacterListRepositoryProtocol) {
        self.repository = repository
    }
    
    func getOnlineCharacters() -> AnyPublisher<CharacterListResponse, APIError> {
        return repository.getOnlineCharacters()
    }
    
    func getCachedCharacters() -> AnyPublisher<[Character], CoreDataError> {
        return repository.getCachedCharacters()
    }
    
    func saveCharactersToCache(characters: [Character]) -> AnyPublisher<Void, CoreDataError> {
        return repository.saveCharactersToCache(characters: characters)
    }
}
