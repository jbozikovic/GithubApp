//
//  DetailsCell.swift
//  GithubApp
//
//  Created by Jurica Bozikovic on 27.03.2023..
//  Copyright © 2023 CocodeLab. All rights reserved.
//

import UIKit

class DetailsCell: UITableViewCell, Configurable {
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
        
    typealias T = DetailsCellViewModel
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupGUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func setupGUI() {
        backgroundColor = .clear
    }

    func configure(_ item: DetailsCellViewModel) {
        captionLabel.text = item.caption
        valueLabel.text = item.value
    }
}


//  MARK: - Reusable
extension DetailsCell: Reusable {
    static var estimatedHeight: CGFloat {
        return 50.0
    }
}

