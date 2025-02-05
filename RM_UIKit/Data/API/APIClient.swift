//
//  APIClient.swift
//  RM_UIKit
//
//  Created by Anatoliy Ostapenko on 04.02.2025.
//

import Foundation
import Alamofire
import Combine

protocol APIServiceProtocol {
    func getCharacters() -> AnyPublisher<CharacterListResponse, APIError>
    func getDetailCharacter(_ id: Int) -> AnyPublisher<Character, APIError>
}

class APIService: APIServiceProtocol {
    func getCharacters() -> AnyPublisher<CharacterListResponse, APIError> {
        return request(endpoint: .getCharacters)
    }
    func getDetailCharacter(_ id: Int) -> AnyPublisher<Character, APIError> {
        return request(endpoint: .getDetailCharacter(id: id))
    }
}

extension APIService {
    private func request<T: Decodable>(endpoint: APIEndpoint, method: HTTPMethod = .get) -> AnyPublisher<T, APIError> {
        
        return AF.request(
            endpoint.url,
            method: method,
            encoding: URLEncoding.default
        )
        .validate()
        .publishDecodable(type: T.self)
        .tryMap { response -> T in
            if let error = response.error {
                if let afError = error.asAFError {
                    if afError.isSessionTaskError,
                       let nsError = afError.underlyingError as? NSError,
                       nsError.code == NSURLErrorNotConnectedToInternet {
                        throw APIError.offline
                    }
                }
                throw APIError.requestFailed(error)
            }

            guard let value = response.value else {
                throw APIError.decodingError(response.error ?? AFError.responseValidationFailed(reason: .dataFileNil))
            }
            return value
        }
        .mapError { error -> APIError in
            if let apiError = error as? APIError {
                return apiError
            }
            return .unknown(error)
        }
        .eraseToAnyPublisher()
    }
}
