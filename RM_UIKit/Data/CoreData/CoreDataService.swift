//
//  CoreDataService.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 05.02.2025.
//

import CoreData
import Combine

protocol DBServiceProtocol {
    func saveCharacter(_ character: Character) -> AnyPublisher<Void, CoreDataError>
    func fetchAllCharacters() -> AnyPublisher<[Character], CoreDataError>
    func deleteAllCharacters() -> AnyPublisher<Void, CoreDataError>
    func fetchDetailCharacter(id: Int) -> AnyPublisher<Character?, CoreDataError>
}

final class CoreDataService: DBServiceProtocol {
    private let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: Environment.dbModel)
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveCharacter(_ character: Character) -> AnyPublisher<Void, CoreDataError> {
        return Future { promise in
            let context = self.viewContext
            let cachedCharacter = CachedCharacter(context: context)
            cachedCharacter.id = Int64(character.id)
            cachedCharacter.name = character.name
            cachedCharacter.status = character.status
            cachedCharacter.species = character.species
            cachedCharacter.gender = character.gender
            cachedCharacter.imageURL = character.image
            cachedCharacter.locationName = character.location.name

            do {
                try self.saveContext()
                promise(.success(()))
            } catch {
                promise(.failure(.failedToSave(error)))
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchAllCharacters() -> AnyPublisher<[Character], CoreDataError> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<CachedCharacter> = CachedCharacter.fetchRequest()
            do {
                let characters = try self.viewContext.fetch(fetchRequest).map { $0.toDomain() }
                promise(.success(characters))
            } catch {
                promise(.failure(.fetchFailed(error)))
            }
        }
        .eraseToAnyPublisher()
    }

    func deleteAllCharacters() -> AnyPublisher<Void, CoreDataError> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<CachedCharacter> = CachedCharacter.fetchRequest()
            do {
                let characters = try self.viewContext.fetch(fetchRequest)
                characters.forEach { self.viewContext.delete($0) }
                try self.saveContext()
                promise(.success(()))
            } catch {
                promise(.failure(.deletionFailed(error)))
            }
        }
        .eraseToAnyPublisher()
    }

    func fetchDetailCharacter(id: Int) -> AnyPublisher<Character?, CoreDataError> {
        return Future { promise in
            let fetchRequest: NSFetchRequest<CachedCharacter> = CachedCharacter.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            fetchRequest.fetchLimit = 1

            do {
                let cached = try self.viewContext.fetch(fetchRequest).first?.toDomain()
                promise(.success(cached))
            } catch {
                promise(.failure(.fetchFailed(error)))
            }
        }
        .eraseToAnyPublisher()
    }

    // MARK: Helpers
    private func saveContext() throws {
        guard viewContext.hasChanges else { return }
        try viewContext.save()
    }
}

