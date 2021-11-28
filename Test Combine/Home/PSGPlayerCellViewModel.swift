//
//  PSGPlayerViewModel.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 12/11/2021.
//

import Foundation

// MARK: - Vue modèle d'un joueur du PSG
final class PSGPlayerCellViewModel: PSGPlayerCell {
    let player: PSGPlayer
    let image: String
    let number: Int
    let name: String
    let position: String
    let fromPSGformation: Bool
    
    // Injection de dépendance
    init(player: PSGPlayer) {
        self.player = player
        self.image = player.imageURL
        self.number = player.number
        self.name = player.name
        self.position = player.position
        self.fromPSGformation = player.fromPSGformation
    }
}
