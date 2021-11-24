//
//  APIService.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 01/11/2021.
//

import Foundation
import Combine

final class PSGAPIService: APIService {
    var cancellables = Set<AnyCancellable>()
    private let playersURL = URL(string: "https://raw.githubusercontent.com/Kous92/JSON-test-data-with-GET/main/psgPlayers2021.json")
    
    func fetchPlayers(completion: @escaping (Result<PSGPlayersResponse, APIError>) -> ()) {
        guard let url = playersURL else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        getRequest(url: url, completion: completion)
    }
    
    // MARK: - Couche réseau générique pour un appel HTTP de type GET.
    private func getRequest<T: Decodable>(url: URL, completion: @escaping (Result<T, APIError>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Erreur réseau
            guard error == nil else {
                print(error?.localizedDescription ?? "Erreur réseau")
                completion(.failure(.networkError))
                
                return
            }
            
            // Pas de réponse du serveur
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.failed))
                
                return
            }
            
            switch httpResponse.statusCode {
                // Code 200, vérifions si les données existent
                case (200...299):
                    if let data = data {
                        var output: T?
                        
                        do {
                            output = try JSONDecoder().decode(T.self, from: data)
                        } catch {
                            completion(.failure(.decodeError))
                            return
                        }
                        
                        if let object = output {
                            completion(.success(object))
                        }
                    } else {
                        completion(.failure(.failed))
                    }
                default:
                    completion(.failure(.notFound))
            }
        }
        task.resume()
    }
}
