//
//  PSGPlayerViewModelProtocol.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 15/11/2021.
//

import Foundation

protocol PSGPlayerCell {
    var player: PSGPlayer { get }
    var image: String { get }
    var number: Int { get }
    var name: String { get }
    var position: String { get }
    var fromPSGformation: Bool { get }
}

protocol PSGPlayerDetails: PSGPlayerCell {
    var country: String { get }
    var size: Int { get }
    var weight: Int { get }
    var birthDate: String { get }
    var goals: Int { get }
    var matches: Int { get }
}
