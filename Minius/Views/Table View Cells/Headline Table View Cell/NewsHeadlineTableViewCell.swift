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

    @IBOutlet weak var _sourceName: UILabel! {
        didSet {
            _sourceName.textColor = .white
            _sourceName.hero.id = "sourceName"
            _sourceName.hero.modifiers = [.fade, .useGlobalCoordinateSpace]
        }
    }
    
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
            _titleLabel.isUserInteractionEnabled = false
            _titleLabel.backgroundColor = .clear
            _titleLabel.text = ""
            _titleLabel.textColor = .white
            _titleLabel.hero.id = "lblTitle"
            _titleLabel.hero.modifiers = [.fade, .useGlobalCoordinateSpace]
            
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
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _ivBackground.image = nil
        _titleLabel.removeBlurEffect()
        _titleLabel.alpha = 0
        _sourceName.alpha = 0
    }
    
    func configure(cellViewModel: TopHeadlineCellViewModel) {
        
        _sourceName.text = cellViewModel.sourceName
        _titleLabel.text = cellViewModel.title
        
        fetchImageUseCase?.fetchImage(for: cellViewModel.imageURL ?? "", completionHandler: { [weak self] (image, fromCache) in
            guard let self = self else { return }
            let image = image ?? UIImage(named: "DefaultImage")
            defer {
                self.layoutIfNeeded()
                self.addBlurEffect(for: self._ivBackground)
            }
            self.updateView(with: image, animated: !fromCache)
        })
        
    }
    
    private func updateView(with image: UIImage?, animated: Bool) {
        switch animated {
        case true:
            UIView.transition(with: self._ivBackground, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                self._ivBackground.image = image
            }, completion: { isCompleted in
                UIView.transition(with: self._titleLabel, duration: 0.3, options: [.transitionCrossDissolve], animations: {
                    self._titleLabel.alpha = 1
                    self._sourceName.alpha = 1
                }, completion: nil)
            })
        case false:
            self._ivBackground.image = image
            self._titleLabel.alpha = 1
            self._sourceName.alpha = 1
        }
    }
    
    private func addBlurEffect(for view: UIView) {
        let blurEffectView = UIView().createBlurEffect(style: .dark, alpha: 1)
        view.removeBlurEffect()
        view.addSubview(blurEffectView)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.addDefaultConstraints(referencing: self)
        let height: CGFloat = _titleLabel.text?.heightNeeded(withConstrainedWidth: view.bounds.width, font: _titleLabel.font) ?? 0.5
        let gradientY = abs(1-( height / view.bounds.height ) - 0.25)
        blurEffectView.layer.mask = createGradientLayer(with: bounds, endPoint: CGPoint(x: 0, y: gradientY))
        view.layoutIfNeeded()
    }
    
    func getImage() -> UIImage? {
        return _ivBackground.image
    }
    
}
