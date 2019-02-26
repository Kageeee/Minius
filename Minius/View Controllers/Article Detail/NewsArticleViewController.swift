//
//  NewsArticleViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 26/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import Hero

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
        }
    }
    @IBOutlet private weak var _lblDetailText: UILabel!
    
    var article: NewsArticle!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = article.source.name
        _ivArticleImageView.image = image
        _lblArticleTitle.text = article.title
        _lblDetailText.text = article.content
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
