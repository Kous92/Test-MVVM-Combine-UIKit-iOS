//
//  PSGPlayerDetailsViewModel.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 24/11/2021.
//

import Foundation
import Combine

// MARK: - Vue modèle d'un joueur du PSG (tous les éléments)
final class PSGPlayerDetailsViewModel: PSGPlayerDetails {
    let player: PSGPlayer
    
    @Published private(set) var image: String
    @Published private(set) var number: Int
    @Published private(set) var name: String
    @Published private(set) var position: String
    @Published private(set) var fromPSGformation: Bool
    @Published private(set) var country: String
    @Published private(set) var size: Int
    @Published private(set) var weight: Int
    @Published private(set) var birthDate: String
    @Published private(set) var goals: Int
    @Published private(set) var matches: Int
    
    // Injection de dépendance
    init(player: PSGPlayer) {
        self.player = player
        self.image = player.imageURL
        self.number = player.number
        self.name = player.name
        self.position = player.position
        self.fromPSGformation = player.fromPSGformation
        self.country = player.country
        self.size = player.size
        self.weight = player.weight
        self.birthDate = player.birthDate
        self.goals = player.goals
        self.matches = player.matches
    }
}
