//
//  NewsHeadlineTableViewCell.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit

class NewsHeadlineTableViewCell: UITableViewCell {

    
    // Outlets
    @IBOutlet private weak var _ivBackground: UIImageView!
    @IBOutlet private weak var _overlayView: UIView!
    @IBOutlet private weak var _titleLabel: UILabel!
    
    // Constraints
    @IBOutlet private weak var _overlayViewBottomConstraint: NSLayoutConstraint!
    
    var fetchImageUseCase: FetchImageUseCase? = DependencyInjector.getFetchImageUseCase()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        fetchImageUseCase = nil
        _overlayViewBottomConstraint.constant = bounds.height
    }
    
    func configure(cellViewModel: TopHeadlineCellViewModel) {
        let blurEffectView = UIView().createBlurEffect(style: .dark, alpha: 1)
        blurEffectView.layer.mask = createGradientLayer()
        _overlayView.addSubview(blurEffectView)
        blurEffectView.addDefaultConstraints(referencing: _overlayView)
        _titleLabel.text = cellViewModel.title
        
        guard let imageURL = cellViewModel.imageURL else { return }
        fetchImageUseCase?.fetchImage(for: imageURL, completionHandler: { [weak self] (image) in
            guard let self = self else { return }
            guard let image = image else { return }
            self._ivBackground.image = image
        })
        
    }
    
    
    
}
