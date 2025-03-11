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
    private let repository: CharacterDetailRepositoryProtocol
    
    init(repository: CharacterDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetailCharacter(_ id: Int) -> AnyPublisher<Character, APIError> {
        return repository.getDetailCharacter(id)
    }
    
    func getCachedDetailCharacter(for id: Int) -> AnyPublisher<Character?, CoreDataError> {
        return repository.getCachedDetailCharacter(for: id)
    }
}
