//
//  APIError.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 01/11/2021.
//

import Foundation

enum APIError: String, Error {
    case notFound = "Erreur 404"
    case invalidURL = "Erreur: URL invalide"
    case decodeError = "Erreur au décodage des données"
    case networkError = "Erreur réseau"
    case failed = "Une erreur est survenue"
}
