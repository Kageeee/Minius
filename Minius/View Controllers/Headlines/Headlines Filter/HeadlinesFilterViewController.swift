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
            settingsCollectionView.hero.modifiers = [.cascade(delta: 0.1)]
            settingsCollectionView.backgroundColor = .clear
            settingsCollectionView.register(UINib(nibName: HeadlinesSettingsCollectionViewCell.className, bundle: nil), forCellWithReuseIdentifier: HeadlinesSettingsCollectionViewCell.className)
            settingsCollectionView.delegate = self
        }
    }
    
    var viewModel: HeadlinesFilterViewViewModel!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        viewModel.output.settingsList
            .drive(settingsCollectionView.rx.items(cellIdentifier: HeadlinesSettingsCollectionViewCell.className, cellType: HeadlinesSettingsCollectionViewCell.self)) { (index, cellViewModel, cell) in
                cell.hero.modifiers = [.fade, .translate(x: cell.bounds.width)]
                cell.configure(for: cellViewModel)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        settingsButton.animateButton()
    }
    
    @IBAction func dismissView(_ sender: MiniusButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension HeadlinesFilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/7)
    }
    
}
