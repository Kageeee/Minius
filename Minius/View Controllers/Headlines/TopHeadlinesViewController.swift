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
import RxDataSources

class TopHeadlinesViewController: UIViewController {
    
    @IBOutlet weak var headlinesTableView: UITableView!
    
    var viewModel: TopHeadlinesViewViewModel!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
    }

    private func setupTableView() {
        headlinesTableView.delegate = self
        headlinesTableView.dataSource = nil
        headlinesTableView.register(UINib(nibName: "NewsHeadlineTableViewCell", bundle: nil), forCellReuseIdentifier: "testIdentifier")
        
        _ = viewModel.output.articleList.drive(headlinesTableView.rx.items(cellIdentifier: "testIdentifier", cellType: NewsHeadlineTableViewCell.self)) { (_, cellViewModel: TopHeadlineCellViewModel, cell) in
            cell.configure(cellViewModel: cellViewModel)
            }.disposed(by: disposeBag)

        headlinesTableView.rx
            .modelSelected(TopHeadlineCellViewModel.self)
            .map({ $0.url })
            .bind(to: viewModel.input.tappedURL)
            .disposed(by: disposeBag)
        
        _ = viewModel.output.showDetail.emit(onNext: { (article) in
            self.performSegue(withIdentifier: "showDetail", sender: self)
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? NewsArticleViewController, let selectedArticle = viewModel.getSelectedArticle() {
            destination.article = selectedArticle
        }
    }

}

extension TopHeadlinesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return headlinesTableView.bounds.height / 2
    }

}
