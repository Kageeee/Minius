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
    
    var getTopHeadlinesUseCase: GetTopHeadlinesUseCase!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        getTopHeadlinesUseCase.getTopHeadlines(for: .Portugal) { (articles) in
            print(articles?.count)
        }
        
    }


}

