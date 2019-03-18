//
//  HeadlinesFilterViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 27/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Hero

class HeadlinesFilterViewController: BaseViewController {

    @IBOutlet weak var _settingsButton: MiniusButton! {
        didSet {
            _settingsButton.hero.id = "settingsButton"
            _settingsButton.hero.modifiers = [.arc(intensity: -1), .rotate(.pi), .useGlobalCoordinateSpace]
        }
    }
    @IBOutlet weak var _settingsCollectionView: UICollectionView!
    
    var viewModel: HeadlinesFilterViewViewModel!
    
    private let _disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupViewModel()
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupViewModel() {
        viewModel.output
            .settingsList
            .drive(_settingsCollectionView.rx.items(cellIdentifier: HeadlinesSettingsCollectionViewCell.className, cellType: HeadlinesSettingsCollectionViewCell.self)) { (index, cellViewModel, cell) in
                cell.hero.modifiers = [.fade, .translate(y: self.view.bounds.height - self._settingsButton.center.y)]
                cell.configure(for: cellViewModel)
            }
            .disposed(by: _disposeBag)
        
        viewModel.output
            .showDetail
            .emit(onNext: { [unowned self] _ in
                self.performSegue(withIdentifier: "settingsEdit", sender: self)
            })
            .disposed(by: _disposeBag)
        
        viewModel.output
            .settingsListCount
            .drive(onNext: { itemsCount in
                let topInset: CGFloat = CGFloat(itemsCount) * self._settingsCollectionView.bounds.height/7
                let rightInset: CGFloat = self._settingsCollectionView.bounds.width - self._settingsButton.center.x
                self._settingsCollectionView.contentInset = UIEdgeInsets(top: topInset, left: 0, bottom: 0, right: rightInset)
            })
            .disposed(by: _disposeBag)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.input.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func dismissView(_ sender: MiniusButton) {
        hero.dismissViewController()
    }
    
    private func setupCollectionView() {
        _settingsCollectionView.hero.modifiers = [.cascade(delta: 0.1)]
        _settingsCollectionView.backgroundColor = .clear
        _settingsCollectionView.register(UINib(nibName: HeadlinesSettingsCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HeadlinesSettingsCollectionViewCell.className)
        
        _settingsCollectionView.rx
            .setDelegate(self)
            .disposed(by: _disposeBag)
        
        _settingsCollectionView.rx
            .modelSelected(HeadlineFilterCellViewModel.self).subscribe(onNext: { [unowned self] (model) in
                self.viewModel.input.tappedFilter(with: model.title)
            })
            .disposed(by: _disposeBag)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let destinationVC = segue.destination as? NewsSettingsEditViewController else { return }
        destinationVC.viewModel.input.buildList(for: viewModel.getSelectedFilter())
    }

}

extension HeadlinesFilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/7)
    }
    
}
