//
//  RepositoriesViewController.swift
//  RxIssuesViewer
//
//  Created by Nicholas Swift on 11/29/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RepositoriesViewController: UIViewController {
    
    // Variables
    
    let githubApi = RxGitHubAPI()
    var user: User?
    var disposeBag = DisposeBag()
    
    // UI Elements
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up nav title
        self.navigationItem.title = user?.name
        
        // Set up delegate and datascource
        tableView.delegate = nil
        tableView.dataSource = nil
        
        // Create repo observable
        if let user = self.user {
            let repoObservable: Observable<[Repository]> = self.githubApi.searchForRepositoryWith(user: user)
            
            repoObservable.bindTo(tableView.rx.items(cellIdentifier: "RepositoriesBasicCell", cellType: UITableViewCell.self)) { (index: Int, repo: Repository, cell: UITableViewCell) in
                cell.textLabel?.text = repo.fullName
            }.addDisposableTo(disposeBag)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

