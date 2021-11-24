//
//  PlayerFilter.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 21/11/2021.
//

import Foundation

enum PlayerFilter: String {
    case noFilter = "Aucun filtre"
    case goalkeepers = "Gardiens de but"
    case defenders = "Défenseurs"
    case midfielders = "Milieux de terrain"
    case forwards = "Attaquants"
    case fromPSGFormation = "Joueurs formés au PSG"
    case numberOrder = "Par numéro dans l'ordre croissant"
    case alphabeticalOrder = "Par ordre alphabétique"
}
