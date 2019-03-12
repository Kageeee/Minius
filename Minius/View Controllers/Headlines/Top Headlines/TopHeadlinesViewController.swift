//
//  ViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Hero

class TopHeadlinesViewController: BaseViewController {
    
    @IBOutlet weak var headlinesTableView: UITableView! {
        didSet {
            headlinesTableView.hero.id = "headlinesTableView"
        }
    }
    @IBOutlet weak var settingsButton: UIButton! {
        didSet {
            settingsButton.hero.id = "settingsButton"
            settingsButton.hero.modifiers = [.rotate(90)]
        }
    }
    
    @IBAction func showSettingsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: self)        
    }
    
    var viewModel: TopHeadlinesViewViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
//        HeroDebugPlugin.isEnabled = true
        super.viewDidLoad()
        title = "Minius"
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
        setupViewModel()
    }

    private func setupTableView() {
        headlinesTableView.delegate = self
        headlinesTableView.dataSource = nil
        headlinesTableView.tableFooterView = UIView()
        headlinesTableView.backgroundColor = .clear
        headlinesTableView.register(UINib(nibName: NewsHeadlineTableViewCell.className, bundle: nil), forCellReuseIdentifier: NewsHeadlineTableViewCell.className)
        
        setupRefreshControl()
        
        headlinesTableView.rx
            .modelSelected(TopHeadlineCellViewModel.self)
            .subscribe(onNext: { [unowned self] model in
                self.viewModel.input.tappedURL(with: model.url)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadNews), for: .valueChanged)
        headlinesTableView.refreshControl = refreshControl
    }
    
    @objc private func reloadNews() {
        headlinesTableView.refreshControl?.beginRefreshing()
        viewModel.input.reloadNews()
    }
    
    private func setupViewModel() {
        viewModel.output.articleList
            .drive(headlinesTableView.rx.items(cellIdentifier: NewsHeadlineTableViewCell.className, cellType: NewsHeadlineTableViewCell.self)) { (_, cellViewModel: TopHeadlineCellViewModel, cell) in
                cell.configure(cellViewModel: cellViewModel)
            }.disposed(by: disposeBag)
        
        viewModel.output.showDetail
            .emit(onNext: { (article) in
                self.performSegue(withIdentifier: "showDetail", sender: self)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.showTableView
            .drive(onNext: { [weak self] show in
                guard let self = self else { return }
                guard show else { return }
                self.headlinesTableView.refreshControl?.endRefreshing()
                self.headlinesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                UIView.animate(withDuration: 0.3, animations: {
                    self.headlinesTableView.alpha = 1
                })
            }).disposed(by: disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NewsArticleViewController, let selectedArticle = viewModel.getSelectedArticle() else { return }
        destination.viewModel.loadArticle(for: selectedArticle)
    }

}

extension TopHeadlinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return headlinesTableView.bounds.height / 3
    }

}
