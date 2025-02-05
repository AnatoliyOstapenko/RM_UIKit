//
//  CharactersViewModel.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import Combine
import UIKit

class CharactersViewModel {
    @Published var characters: [Character] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let characterListUseCase: CharacterListUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(characterListUseCase: CharacterListUseCase) {
        self.characterListUseCase = characterListUseCase
        loadCharacters()
    }
}
// MARK: Online mode
extension CharactersViewModel {
    func loadCharacters() {
        isLoading = true
        characterListUseCase.getOnlineCharacters()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    loadCachedCharacters()
                    self.errorMessage = error.errorDescription
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.characters = response.results
                self.saveCharactersToCache(characters: response.results)
            })
            .store(in: &cancellables)
    }
}
 
// MARK: Offline mode
extension CharactersViewModel {
    func loadCachedCharacters() {
        isLoading = true
        characterListUseCase.getCachedCharacters()
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.errorDescription
                }
            }, receiveValue: { [weak self] cached in
                guard let self = self else { return }
                self.characters = cached
            })
            .store(in: &cancellables)
    }
    
    private func saveCharactersToCache(characters: [Character]) {
        isLoading = true
        characterListUseCase.saveCharactersToCache(characters: characters)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.errorDescription
                }
            }, receiveValue: {})
            .store(in: &cancellables)
    }
}
