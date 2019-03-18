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
    
    @IBOutlet weak var dummyView: UIView! {
        didSet {
            dummyView.hero.id = "dummyView"
            dummyView.backgroundColor = .clear
        }
    }
    @IBOutlet weak var headlinesTableView: UITableView! {
        didSet {
            headlinesTableView.backgroundColor = .clear
            headlinesTableView.hero.id = "headlinesTableView"
            
        }
    }
    @IBOutlet weak var settingsButton: UIButton! {
        didSet {
            settingsButton.hero.id = "settingsButton"
            settingsButton.hero.modifiers = [.arc()]
        }
    }
    
    @IBAction func showSettingsPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showSettings", sender: self)        
    }
    
    var viewModel: TopHeadlinesViewViewModel!
    
    var fadeView = UIView()
    private var _gradientLayer: CAGradientLayer!
    
    private let _disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Minius"
        
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showSettingsButton(isHidden: false)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateGradientFrame()
    }
    
    private func setupTableViewGradientFrame() {
        _gradientLayer = CAGradientLayer()
        _gradientLayer.locations = [0, 0.02, 0.98, 1]
        let colors: [CGColor] = [UIColor.clear.cgColor, UIColor.black.cgColor, UIColor.black.cgColor, UIColor.clear.cgColor]
        _gradientLayer.colors = colors
        _gradientLayer.type = .axial
        _gradientLayer.frame = headlinesTableView.bounds
        headlinesTableView.layer.mask = _gradientLayer
    }
    
    private func updateGradientFrame() {
        self._gradientLayer.frame = CGRect(origin: .zero, size: self.headlinesTableView.contentSize)
    }
    
    private func setupTableView() {
        setupTableViewGradientFrame()
        
        headlinesTableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        
        headlinesTableView.rx
            .setDelegate(self)
            .disposed(by: _disposeBag)
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
            .disposed(by: _disposeBag)
        
        headlinesTableView.rx
            .didScroll
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                let top = 64 - self.headlinesTableView.contentOffset.y
                self.headlinesTableView.contentInset = UIEdgeInsets(top: top < 0 ? top : 0, left: 0, bottom: 0, right: 0)
                self.updateGradientFrame()
                self.showSettingsButton(isHidden: true)
            })
            .disposed(by: _disposeBag)
        
        headlinesTableView.rx
            .didEndDecelerating
            .observeOn(MainScheduler.asyncInstance)
            .subscribe(onNext: {
                self.showSettingsButton(isHidden: false)
            })
            .disposed(by: _disposeBag)
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: {
                self.reloadNews()
            })
            .disposed(by: _disposeBag)
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
            }.disposed(by: _disposeBag)
        
        viewModel.output.showDetail
            .emit(onNext: { [unowned self] (article) in
                self.performSegue(withIdentifier: "showDetail", sender: self)
            })
            .disposed(by: _disposeBag)
        
        viewModel.output.showTableView
            .drive(onNext: { [weak self] show in
                guard let self = self else { return }
                guard show else { return }
                self.headlinesTableView.refreshControl?.endRefreshing()
                self.headlinesTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                UIView.animate(withDuration: 0.3, animations: {
                    self.headlinesTableView.alpha = 1
                })
            }).disposed(by: _disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? NewsArticleViewController, let selectedArticle = viewModel.getSelectedArticle() else { return }
        destination.viewModel.loadArticle(for: selectedArticle)
    }
    
    private func showSettingsButton(isHidden: Bool) {
        switch isHidden {
        case true:
            UIView.animate(withDuration: 0.3, animations: {
                self.settingsButton.alpha = 0
            }) { (isCompleted) in
                self.settingsButton.isHidden = true
            }
        case false:
            self.settingsButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.settingsButton.alpha = 1
            })
        }
    }
    
}

extension TopHeadlinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return headlinesTableView.bounds.height / 2.5
    }
    
}
