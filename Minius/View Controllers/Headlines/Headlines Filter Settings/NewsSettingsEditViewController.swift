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

    @IBOutlet weak var settingsEditTableView: UITableView! {
        didSet {
            settingsEditTableView.hero.modifiers = [.cascade(delta: 0.1)]
            settingsEditTableView.backgroundColor = .clear
            settingsEditTableView.register(UINib(nibName: HeadlinesSettingsTableViewCell.className, bundle: nil), forCellReuseIdentifier: HeadlinesSettingsTableViewCell.className)
            settingsEditTableView.delegate = self
        }
    }
    
    private let _disposeBag = DisposeBag()
    
    var viewModel: NewsSettingsEditViewModel!
    
    override func viewDidLoad() {
        isBackgroundTranslucent = true
        super.viewDidLoad()

        viewModel.output
            .settingsList
            .drive(settingsEditTableView.rx.items(cellIdentifier: HeadlinesSettingsTableViewCell.className, cellType: HeadlinesSettingsTableViewCell.self)) { (_, cellViewModel, cell) in
            cell.configure(for: cellViewModel)
        }.disposed(by: _disposeBag)
        // Do any additional setup after loading the view.
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
