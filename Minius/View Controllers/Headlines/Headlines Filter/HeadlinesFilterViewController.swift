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

    @IBOutlet weak var settingsButton: MiniusButton! {
        didSet {
            settingsButton.hero.id = "settingsButton"
        }
    }
    @IBOutlet weak var settingsCollectionView: UICollectionView! {
        didSet {
            setupCollectionView()
        }
    }
    
    var viewModel: HeadlinesFilterViewViewModel!
    
    private let _disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        isBackgroundTranslucent = true
        super.viewDidLoad()
        viewModel.output
            .settingsList
            .drive(settingsCollectionView.rx.items(cellIdentifier: HeadlinesSettingsCollectionViewCell.className, cellType: HeadlinesSettingsCollectionViewCell.self)) { (index, cellViewModel, cell) in
                cell.hero.modifiers = [.fade, .translate(y: cell.bounds.height)]
                cell.configure(for: cellViewModel)
            }
            .disposed(by: _disposeBag)
        
        viewModel.output
            .showDetail
            .emit(onNext: { [unowned self] _ in
            self.performSegue(withIdentifier: "settingsEdit", sender: self)
        }).disposed(by: _disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsButton.animateButton()
    }
    
    @IBAction func dismissView(_ sender: MiniusButton) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupCollectionView() {
        settingsCollectionView.hero.modifiers = [.cascade(delta: 0.1)]
        settingsCollectionView.backgroundColor = .clear
        settingsCollectionView.register(UINib(nibName: HeadlinesSettingsCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HeadlinesSettingsCollectionViewCell.className)
        settingsCollectionView.delegate = self
        
        settingsCollectionView.rx
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
