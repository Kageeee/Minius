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

    @IBOutlet weak var _sourceName: UILabel!
    
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
    @IBOutlet private weak var _titleLabel: UITextView! {
        didSet {
            _titleLabel.isUserInteractionEnabled = false
            _titleLabel.backgroundColor = .clear
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
        backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let path = _titleLabel.convert(_ivBackground.bounds, from: _ivBackground)
        _titleLabel.textContainer.exclusionPaths.append(UIBezierPath(rect: path))
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _ivBackground.image = nil
    }
    
    func configure(cellViewModel: TopHeadlineCellViewModel) {
        
        _sourceName.text = cellViewModel.sourceName
        _titleLabel.text = cellViewModel.title
        
        
        fetchImageUseCase?.fetchImage(for: cellViewModel.imageURL ?? "", completionHandler: { [weak self] (image, fromCache) in
            guard let self = self else { return }
            let image = image ?? UIImage(named: "DefaultImage")
            defer { self.layoutIfNeeded() }
            guard !fromCache else {
                self._ivBackground.image = image
                self._titleLabel.textColor = .white
                return
            }
            UIView.transition(with: self._ivBackground, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                self._ivBackground.image = image
            }, completion: { isCompleted in
                UIView.transition(with: self._titleLabel, duration: 0.3, options: [.transitionCrossDissolve], animations: {
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
