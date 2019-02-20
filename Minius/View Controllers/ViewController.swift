//
//  ViewController.swift
//  Minius
//
//  Created by Miguel Alcântara on 20/02/2019.
//  Copyright © 2019 Miguel Alcântara. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let request = GetTopHeadlinesRequest().toURLRequest() else { return }
        let test: Observable<Result<NewsAPIResponse>> = NetworkClient.shared.execute(request: request)
        
        test.subscribe(onNext: { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error)
            }
        })
        
    }


}

