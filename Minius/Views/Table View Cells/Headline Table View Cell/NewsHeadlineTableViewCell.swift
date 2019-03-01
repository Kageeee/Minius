//
//  NewsHeadlineTableViewCell.swift
//  Minius
//
//  Created by Miguel Alcântara on 25/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import Hero
import RxSwift

class NewsHeadlineTableViewCell: UITableViewCell {

    
    // Outlets
    @IBOutlet private weak var _ivBackground: UIImageView! {
        didSet {
            _ivBackground.hero.id = "ivArticleTitle"
            _ivBackground.contentMode = .scaleAspectFill
        }
    }
    @IBOutlet private weak var _overlayView: UIView! {
        didSet {
            _overlayView.alpha = 0
        }
    }
    @IBOutlet private weak var _titleLabel: UILabel! {
        didSet {
            _titleLabel.hero.id = "lblTitle"
            _titleLabel.hero.modifiers = [.fade]
        }
    }
    
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
//        super.setSelected(selected, animated: animated)
//        _overlayViewBottomConstraint.constant = selected ? _overlayView.bounds.height : 0
//        UIView.animate(withDuration: 1) { [weak self] in
//            self?.layoutIfNeeded()
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _ivBackground.image = nil
    }
    
    func configure(cellViewModel: TopHeadlineCellViewModel) {
        _titleLabel.text = cellViewModel.title
        fetchImageUseCase?.fetchImage(for: cellViewModel.imageURL ?? "", completionHandler: { [weak self] (image) in
            guard let self = self else { return }
            let image = image ?? UIImage(named: "DefaultImage")
            self.layoutIfNeeded()
            self.addBlurEffect()
            UIView.transition(with: self._ivBackground, duration: 1, options: [.transitionCrossDissolve], animations: {
                self._ivBackground.image = image
                self._overlayView.alpha = 1
            }, completion: { isCompleted in
                UIView.transition(with: self._titleLabel, duration: 1, options: [.transitionCrossDissolve], animations: {
                    self._titleLabel.textColor = .white
                }, completion: nil)
            })
        })
        
    }
    
    private func addBlurEffect() {
        let blurEffectView = UIView().createBlurEffect(style: .dark, alpha: 1)
        _overlayView.removeBlurEffect()
        _overlayView.insertSubview(blurEffectView, at: 0)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.addDefaultConstraints(referencing: _overlayView)
        blurEffectView.layer.mask = createGradientLayer(with: _overlayView.bounds)
        _overlayView.layoutIfNeeded()
    }
    
    func getImage() -> UIImage? {
        return _ivBackground.image
    }
    
}
