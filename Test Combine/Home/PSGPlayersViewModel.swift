//
//  PlayerViewModel.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 01/11/2021.
//

import Foundation
import Combine

final class PSGPlayersViewModel {
    // Les sujets, ceux qui émettent et reçoivent des événements
    var updateResult = PassthroughSubject<Bool, APIError>()
    @Published var searchQuery = ""
    @Published var activeFilter: PlayerFilter = .noFilter
    
    private var playersData: PSGPlayersResponse?
    private var playersViewModel = [PSGPlayerCellViewModel]()
    var filteredPlayersViewModels = [PSGPlayerCellViewModel]()
    private let apiService: APIService
    
    // Pour la gestion mémoire et l'annulation des abonnements
    private var subscriptions = Set<AnyCancellable>()
    
    // Injection de dépendance
    init(apiService: APIService = PSGAPIService()) {
        self.apiService = apiService
        setBindings()
        getPlayers()
    }
    
    func getPlayers() {
        apiService.fetchPlayers { [weak self] result in
            switch result {
            case .success(let response):
                self?.playersData = response
                self?.parseData()
            case .failure(let error):
                print(error.rawValue)
                self?.updateResult.send(completion: .failure(error))
            }
        }
    }
    
    private func setBindings() {
        $searchQuery
            .receive(on: RunLoop.main)
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] value in
                self?.searchPlayer()
            }.store(in: &subscriptions)
        
        $activeFilter.receive(on: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] value in
                self?.applyFilter()
            }.store(in: &subscriptions)
    }
}

extension PSGPlayersViewModel {
    private func parseData() {
        guard let data = playersData, data.players.count > 0 else {
            // Pas de joueurs téléchargés
            updateResult.send(false)
            
            return
        }
        
        data.players.forEach { playersViewModel.append(PSGPlayerCellViewModel(player: $0)) }
        filteredPlayersViewModels = playersViewModel
        updateResult.send(true)
    }
    
    // Étant donné qu'il n'y a pas une API adapatée, on va simuler la recherche en filtrant les résultats parmi les joueurs téléchargés initialement.
    private func searchPlayer() {
        // Si le contenu vide, alors il n'y a aucun filtre à appliquer et le contenu de liste contient de nouveau tous les joueurs.
        guard !searchQuery.isEmpty else {
            activeFilter = .noFilter
            filteredPlayersViewModels = playersViewModel
            updateResult.send(true)
            
            return
        }
        
        filteredPlayersViewModels = playersViewModel.filter { $0.name.lowercased().contains(searchQuery.lowercased()) }
        
        if filteredPlayersViewModels.count > 0 {
            updateResult.send(true)
        } else {
            updateResult.send(false)
        }
    }
    
    private func applyFilter() {
        switch activeFilter {
        case .noFilter:
            filteredPlayersViewModels = playersViewModel
        case .numberOrder:
            // Tri par numéro dans l'ordre croissant
            filteredPlayersViewModels = playersViewModel.sorted(by: { player1, player2 in
                return player1.number < player2.number
            })
        case .goalkeepers:
            // Les gardiens de but
            filteredPlayersViewModels = playersViewModel.filter { $0.position == "Gardien de but" }
        case .defenders:
            // Les défenseurs
            filteredPlayersViewModels = playersViewModel.filter { $0.position == "Latéral droit" || $0.position == "Défenseur central" || $0.position == "Défenseur" || $0.position == "Latéral gauche" }
        case .midfielders:
            // Les milieux de terrain
            filteredPlayersViewModels = playersViewModel.filter { $0.position == "Milieu" || $0.position == "Milieu offensif" || $0.position == "Milieu défensif" }
        case .forwards:
            // Les attaquants
            filteredPlayersViewModels = playersViewModel.filter { $0.position == "Attaquant" || $0.position == "Avant-centre" }
        case .fromPSGFormation:
            filteredPlayersViewModels = playersViewModel.filter { $0.player.fromPSGformation }
        case .alphabeticalOrder:
            filteredPlayersViewModels = playersViewModel.sorted(by: { player1, player2 in
                return player1.name < player2.name
            })
        }
        
        updateResult.send(true)
    }
}

