//
//  NewsArticleViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 26/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import Hero
import RxSwift
import RxCocoa

class NewsArticleViewController: UIViewController {

    @IBOutlet private weak var _articleScrollView: UIScrollView!
    @IBOutlet private weak var _articleContentView: UIView!
    @IBOutlet private weak var _ivArticleImageView: UIImageView! {
        didSet {
            _ivArticleImageView.contentMode = .scaleAspectFill
            _ivArticleImageView.hero.id = "ivArticleTitle"
        }
    }
    
    @IBOutlet private weak var _lblArticleTitle: UILabel! {
        didSet {
            _lblArticleTitle.hero.id = "lblTitle"
            _lblArticleTitle.hero.modifiers = [.fade]
        }
    }
    
    @IBOutlet private weak var _lblDetailText: UILabel!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: NewsArticleViewViewModel!
    var article: NewsArticle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewModel()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupViewModel() {
        viewModel.output.showImage
            .drive(_ivArticleImageView.rx.image)
            .disposed(by: disposeBag)
        
        viewModel.output.populateTitle
            .drive(_lblArticleTitle.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.populateDetail
            .drive(_lblDetailText.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.output.viewTitle
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 
}
