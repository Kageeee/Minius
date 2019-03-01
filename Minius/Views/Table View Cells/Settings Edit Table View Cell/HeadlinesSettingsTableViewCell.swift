//
//  HeadlinesSettingsCollectionViewCell.swift
//  Minius
//
//  Created by Miguel Alcântara on 28/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit

class HeadlinesSettingsTableViewCell: UITableViewCell {

    @IBOutlet private weak var _ivSettingsType: UIImageView!
    @IBOutlet private weak var _lblSettings: UILabel! {
        didSet {
            _lblSettings.textColor = .lightText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(for cellViewModel: HeadlineFilterCellViewModel) {
        _ivSettingsType.image   = UIImage(named: cellViewModel.imageTitle)
        _lblSettings.text       = cellViewModel.title
    }

    private func setupImageView() {
        _ivSettingsType.contentMode = .scaleAspectFill
    }
}
