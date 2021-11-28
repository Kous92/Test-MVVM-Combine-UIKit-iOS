//
//  PSGPlayerFiltersViewController.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 21/11/2021.
//

import UIKit
import Combine

final class PSGPlayerFiltersViewController: UIViewController {

    let viewModel = PSGPlayersFiltersViewModel()
    private var actualSelectedIndex = 0
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    @IBAction func backToMainView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PSGPlayerFiltersViewController {
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension PSGPlayerFiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.filters.count)
        return viewModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = viewModel.filters[indexPath.row].rawValue
        
        // Inutile de réutiliser les cellules vu qu'il y a peu de catégories
        let cell = UITableViewCell(style: .default, reuseIdentifier: "filterCell")
        cell.textLabel?.text = filter
        cell.textLabel?.textColor = .white
        cell.tintColor = .systemGreen
        cell.backgroundColor = .clear
        
        if viewModel.actualFilter.rawValue == filter {
            actualSelectedIndex = indexPath.row
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
}

extension PSGPlayerFiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Désélectionner la ligne.
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        // L'utilisateur a-t-il tapé sur un cellule déjà sélectionnée ? Si c'est le cas, ne rien faire.
        let selected = indexPath.row
        if selected == actualSelectedIndex {
            return
        }
        
        // Suppression du coche de l'ancienne cellule sélectionnée
        if let previousCell = tableView.cellForRow(at: IndexPath(row: actualSelectedIndex, section: indexPath.section)) {
            previousCell.accessoryType = .none
        }
        
        // On marque la cellule nouvellement sélectionnée avec un coche
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        
        // On garde en mémoire la catégorie séléctionnée
        actualSelectedIndex = selected
        viewModel.actualFilter = viewModel.filters[indexPath.row]
        viewModel.selectedFilter.send(viewModel.filters[indexPath.row])
    }
}
