//
//  RMCoordinator.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import UIKit

protocol RMCoordinatorProtocol: Coordinator {
    func showDetail(for character: Character)
}

class RMCoordinator: RMCoordinatorProtocol {
    private let navController: UINavigationController
    private let apiService: APIServiceProtocol
    private let dbService: DBServiceProtocol
    private let networkMonitor: NetworkMonitor

    init(navController: UINavigationController, apiService: APIServiceProtocol, dbService: DBServiceProtocol, networkMonitor: NetworkMonitor) {
        self.navController = navController
        self.apiService = apiService
        self.dbService = dbService
        self.networkMonitor = networkMonitor
    }

    func start() {
        let characterListUseCase = CharacterListUseCase(
            apiClient: apiService,
            dbClient: dbService
        )
        let viewModel = CharactersViewModel(
            characterListUseCase: characterListUseCase,
            networkMonitor: networkMonitor
        )
        let vc = CharactersViewController(viewModel: viewModel)
        vc.coordinator = self
        navController.pushViewController(vc, animated: false)
    }

    func showDetail(for character: Character) {
        let characterDetailUseCase = CharacterDetailUseCase(
            apiClient: apiService,
            dbClient: dbService
        )
        let detailViewModel = DetailViewModel(
            characterId: character.id,
            characterDetailUseCase: characterDetailUseCase,
            networkMonitor: networkMonitor
        )
        let detailVC = DetailViewController(
            viewModel: detailViewModel,
            characterName: character.name
        )
        navController.pushViewController(detailVC, animated: true)
    }
}

