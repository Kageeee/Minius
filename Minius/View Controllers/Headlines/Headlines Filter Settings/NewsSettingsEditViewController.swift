//
//  NewsSettingsEditViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 01/03/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import Hero
import RxCocoa
import RxSwift

class NewsSettingsEditViewController: BaseViewController {

    @IBOutlet weak var settingsEditTableView: UITableView!
    
    private let _disposeBag = DisposeBag()
    
    var viewModel: NewsSettingsEditViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupTableView() {
        settingsEditTableView.hero.modifiers = [.cascade(delta: 0.1)]
        settingsEditTableView.register(UINib(nibName: HeadlinesSettingsTableViewCell.className, bundle: nil), forCellReuseIdentifier: HeadlinesSettingsTableViewCell.className)
        settingsEditTableView.delegate = self
    
    }
    
    private func setupViewModel() {
        viewModel.output
            .settingsList
            .drive(settingsEditTableView.rx.items(cellIdentifier: HeadlinesSettingsTableViewCell.className, cellType: HeadlinesSettingsTableViewCell.self)) { (index, cellViewModel, cell) in
                cell.hero.modifiers = [.fade, .translate(y: cell.bounds.height)]
                cell.configure(for: cellViewModel)
            }.disposed(by: _disposeBag)
        
        Observable.zip(settingsEditTableView.rx.modelSelected(HeadlineFilterCellViewModel.self), settingsEditTableView.rx.itemSelected)
            .subscribe(onNext: { [unowned self] (cellViewModel, indexPath) in
                self.viewModel.input.tappedCell(with: cellViewModel.value)
//                guard let cell = self.settingsEditTableView.cellForRow(at: indexPath) as? HeadlinesSettingsTableViewCell else { return }
                self.hero.dismissViewController()
            })
            .disposed(by: _disposeBag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension NewsSettingsEditViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 7
    }
    
}
