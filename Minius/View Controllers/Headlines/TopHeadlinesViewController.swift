//
//  ViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import RxSwift

class TopHeadlinesViewController: UIViewController {
    
    @IBOutlet weak var headlinesTableView: UITableView!
    
    var getTopHeadlinesUseCase: GetTopHeadlinesUseCase!
    
    var feed: [TopHeadlineCellViewModel]? {
        didSet {
            headlinesTableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupTableView()
        getTopHeadlinesUseCase.getTopHeadlines(for: .Portugal) { (articles) in
            print(articles?.count)
            guard let articles = articles else { return }
            self.feed = articles.map { TopHeadlineCellViewModel(imageURL: $0.urlToImage, title: $0.title) }
        }
        
    }

    private func setupTableView() {
        headlinesTableView.delegate = self
        headlinesTableView.dataSource = self
        headlinesTableView.register(UINib(nibName: "NewsHeadlineTableViewCell", bundle: nil), forCellReuseIdentifier: "testIdentifier")
    }

}

extension TopHeadlinesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feed?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "testIdentifier") as? NewsHeadlineTableViewCell,
            let cellViewModel = feed?[indexPath.row] else { fatalError() }
        cell.configure(cellViewModel: cellViewModel)
        return cell
    }
    
}
