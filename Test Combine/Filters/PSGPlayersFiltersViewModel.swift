//
//  PSGPlayersFiltersViewModel.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 21/11/2021.
//

import Foundation
import Combine

final class PSGPlayersFiltersViewModel {
    let selectedFilter = PassthroughSubject<PlayerFilter, Never>()
    var actualFilter: PlayerFilter = .noFilter
    var filters = [PlayerFilter]()
    
    init() {
        initFilterList()
    }
    
    private func initFilterList() {
        filters.append(.noFilter)
        filters.append(.goalkeepers)
        filters.append(.defenders)
        filters.append(.midfielders)
        filters.append(.forwards)
        filters.append(.fromPSGFormation)
        filters.append(.numberOrder)
        filters.append(.alphabeticalOrder)
    }
    
    func setFilter(savedFilter: PlayerFilter = .noFilter) {
        actualFilter = savedFilter
        selectedFilter.send(savedFilter)
    }
}
