//
//  IssuesViewController.swift
//  RxIssuesViewer
//
//  Created by Nicholas Swift on 12/1/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class IssuesViewController: UIViewController {
    
    // Variables
    
    let githubApi = RxGitHubAPI()
    var repo: Repository?
    var disposeBag = DisposeBag()
    
    // UI Elements
    
    
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
