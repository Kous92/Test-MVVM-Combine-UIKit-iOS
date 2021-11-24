//
//  PSGPlayerTableViewCell.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 12/11/2021.
//

import UIKit

final class PSGPlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImage: CachedImageView!
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var playerPositionLabel: UILabel!
    
    private var viewModel: PSGPlayerCell!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // Injection de dépendance
    func configure(with viewModel: PSGPlayerCell) {
        self.viewModel = viewModel
        setView()
    }
    
    func setView() {
        if let imageURL = URL(string: viewModel.image) {
            playerImage.loadImage(fromURL: imageURL)
        } else {
            playerImage.image = UIImage(systemName: "questionmark.circle")
        }
        
        playerNumberLabel.text = String(viewModel.number)
        playerPositionLabel.text = viewModel.position
        playerNameLabel.text = viewModel.name
    }
}
