//
//  Player.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 01/11/2021.
//

import Foundation

/* Lors du décodage d'objets JSON en objets Swift, il est préférable de conformer la structure seulement au protocole Decodable vu qu'on ne fait pas d'encodage d'objects Swift en objets JSON (par exemple dans le cas d'un body pour un appel HTTP POST, PUT ou DELETE.
 -> Cela respecte ainsi l'un des 5 principes du SOLID étant le 4ème (I): Interface Segregation Principle (ISP)
 -> Le principe de ségrégation d'interface est qu'une entité n'est aucunement dans l'obligation d'implémenter des méthodes qu'il n'utilise pas. Cela aide aussi au respect du 1er principe du SOLID (S): Single Responsibility Principle (SRP) pour principe de responsabilité unique.
*/
struct PSGPlayersResponse: Decodable, Hashable {
    var players: [PSGPlayer]
}

struct PSGPlayer: Decodable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    public static func == (lhs: PSGPlayer, rhs: PSGPlayer) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: Int
    var name: String
    var number: Int
    var country: String
    var size, weight: Int
    var birthDate: String
    var position: String
    var goals, matches: Int
    var fromPSGformation: Bool
    var imageURL: String
}
