//
//  CharactersViewModel.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import Combine
import UIKit

class CharactersViewModel {
    typealias Entity = [Character]
    @Published var characters: [Character] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let characterListUseCase: CharacterListUseCase
    private let networkMonitor: NetworkMonitorProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(characterListUseCase: CharacterListUseCase, networkMonitor: NetworkMonitorProtocol) {
        self.characterListUseCase = characterListUseCase
        self.networkMonitor = networkMonitor
        getCharacters()
    }
    
    func getCharacters() {
        networkMonitor.isConnected
            .removeDuplicates()
            .sink { [weak self] isConnected in
                guard let self = self else { return }
                if isConnected {
                    self.loadCharacters()
                } else {
                    self.loadCachedCharacters() { _ in }
                }
            }
            .store(in: &cancellables)
    }
}
// MARK: Online mode
extension CharactersViewModel {
    private func loadCharacters() {
        isLoading = true
        characterListUseCase.getOnlineCharacters()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.loadCachedCharacters { success in
                        /// Prevent showing error and empty state if characters are available in db
                        if !success {
                            self.errorMessage = error.errorDescription
                        }
                    }
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
    private func loadCachedCharacters(completion: @escaping (Bool) -> Void)  {
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
