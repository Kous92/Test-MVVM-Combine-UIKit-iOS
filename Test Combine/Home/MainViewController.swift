//
//  ViewController.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 01/11/2021.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var appliedFilterLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var noResultLabel: UILabel!
    
    @Published private(set) var searchQuery = ""
    private var subscriptions = Set<AnyCancellable>()
    private var viewModel = PSGPlayersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setSearchBar()
        setNoResultLabel()
        setBindings()
    }
    
    @IBAction func filterButton(_ sender: Any) {
        guard let filterViewController = storyboard?.instantiateViewController(withIdentifier: "filtersViewController") as? PSGPlayerFiltersViewController else {
            fatalError("Le ViewController n'est pas détecté dans le Storyboard.")
        }
        
        func setFilterVCBinding() {
            // On garde en mémoire le filtre sélectionné
            filterViewController.viewModel.setFilter(savedFilter: viewModel.activeFilter)
            
            // Ici, on remplace la délégation par un binding par le biais d'un PassthroughSubject
            filterViewController.viewModel.selectedFilter
                .handleEvents(receiveOutput: { [weak self] filter in
                    self?.appliedFilterLabel.text = filter.rawValue
                    self?.viewModel.activeFilter = filter
                }).sink { _ in }
                .store(in: &subscriptions)
        }
        
        setFilterVCBinding()
        filterViewController.modalPresentationStyle = .fullScreen
        self.present(filterViewController, animated: true, completion: nil)
    }
}

// MARK: - Fonctions pour la gestion des vues et des liens avec la vue modèle
extension MainViewController {
    private func setTableView() {
        // Configuration TableView
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setSearchBar() {
        // Configuration barre de recherche
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Annuler"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.backgroundImage = UIImage() // Supprimer le fond par défaut
        searchBar.showsCancelButton = false
        searchBar.delegate = self
    }
    
    private func setNoResultLabel() {
        noResultLabel.isHidden = false
        noResultLabel.text = ""
    }
    
    private func displayNoResult() {
        tableView.isHidden = true
        noResultLabel.isHidden = false
        noResultLabel.text = "Aucun résultat pour \"\(searchQuery)\". Veuillez réessayer avec une autre recherche."
    }
    
    private func updateTableView() {
        noResultLabel.isHidden = true
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    private func setBindings() {
        func setSearchBinding() {
            $searchQuery
                .receive(on: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] value in
                    print(value)
                    self?.viewModel.searchQuery = value
                }.store(in: &subscriptions)
        }
        
        func setUpdateBinding() {
            viewModel.updateResult.receive(on: RunLoop.main).sink { completion in
                switch completion {
                case .finished:
                    print("OK: terminé")
                case .failure(let error):
                    print("Erreur reçue: \(error.rawValue)")
                }
            } receiveValue: { [weak self] updated in
                self?.loadingSpinner.stopAnimating()
                self?.loadingSpinner.isHidden = true
                
                if updated {
                    self?.updateTableView()
                } else {
                    self?.displayNoResult()
                }
            }.store(in: &subscriptions)
        }
        
        func setActiveFilterBinding() {
            viewModel.$activeFilter
                .receive(on: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] value in
                    print(value)
                    self?.viewModel.activeFilter = value
                }.store(in: &subscriptions)
        }
        
        // L'intérêt d'utiliser des fonctions imbriquées est de pouvoir respecter le 1er prinicipe du SOLID étant le principe de responsabilité unique (SRP: Single Responsibility Principle)
        setSearchBinding()
        setUpdateBinding()
        setActiveFilterBinding()
    }
}

// MARK: - Fonctions de la source de données pour le TableView
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredPlayersViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PSGPlayerTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.filteredPlayersViewModels[indexPath.row])
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "detailsViewController") as? PSGPlayerDetailsViewController else {
            fatalError("Le ViewController n'est pas détecté dans le Storyboard.")
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        detailsViewController.configure(with: PSGPlayerDetailsViewModel(player: viewModel.filteredPlayersViewModels[indexPath.row].player))
        detailsViewController.modalPresentationStyle = .fullScreen
        present(detailsViewController, animated: true, completion: nil)
    }
}

// MARK: - Fonctions de la barre de recherche
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(true, animated: true) // Afficher le bouton d'annulation
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchQuery = searchText
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchQuery = ""
        self.searchBar.text = ""
        self.appliedFilterLabel.text = "Aucun filtre"
        searchBar.resignFirstResponder() // Masquer le clavier et stopper l'édition du texte
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Masquer le clavier et stopper l'édition du texte
        self.searchBar.setShowsCancelButton(false, animated: true) // Masquer le bouton d'annulation
    }
}
