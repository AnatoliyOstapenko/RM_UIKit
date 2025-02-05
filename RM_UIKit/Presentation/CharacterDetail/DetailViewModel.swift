//
//  DetailViewModel.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import UIKit
import Combine

class DetailViewModel {
    @Published var character: Character?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let characterId: Int
    private let characterDetailUseCase: CharacterDetailUseCase
    private var cancellables = Set<AnyCancellable>()
    
    
    init(characterId: Int, characterDetailUseCase: CharacterDetailUseCase) {
        self.characterId = characterId
        self.characterDetailUseCase = characterDetailUseCase
        fetchDetailCharacter()
    }
}

// MARK: Online mode
extension DetailViewModel {
    func fetchDetailCharacter() {
        isLoading = true
        characterDetailUseCase.getDetailCharacter(characterId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.loadCachedCharacter { success in
                        if !success {
                            self.errorMessage = error.errorDescription
                        }
                    }
                }
            }, receiveValue: { [weak self] character in
                guard let self = self else { return }
                self.character = character
            })
            .store(in: &cancellables)
    }
}

// MARK: Offline mode
extension DetailViewModel {
    func loadCachedCharacter(completion: @escaping (Bool) -> Void) {
        isLoading = true
        characterDetailUseCase.getCachedDetailCharacter(for: characterId)
            .sink(receiveCompletion: { [weak self] completionResult in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure(let error) = completionResult {
                    self.errorMessage = error.errorDescription
                    completion(false)
                }
            }, receiveValue: { [weak self] cached in
                guard let self = self else { return }
                self.character = cached
                completion(true)
            })
            .store(in: &cancellables)
    }
}

