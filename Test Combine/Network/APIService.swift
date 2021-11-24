//
//  APIService.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 12/11/2021.
//

import Foundation

protocol APIService {
    func fetchPlayers(completion: @escaping (Result<PSGPlayersResponse, APIError>) -> ())
}
