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
    var user: User?
    var disposeBag = DisposeBag()
    
    // UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up delegate and datascource
        tableView.delegate = nil
        tableView.dataSource = nil
        
        // Check user
        guard let user = self.user else {
            return
        }
        
        // Check repo
        guard let repo = self.repo else {
            return
        }
        
        // Create issues observable
        let issuesObservable: Observable<[Issue]> = self.githubApi.searchForIssuesWith(user: user, repository: repo)
        
        issuesObservable.bindTo(tableView.rx.items(cellIdentifier: "IssueCell", cellType: IssueCell.self)) { (index: Int, issue: Issue, cell: IssueCell) in
            cell.issueTitleLabel.text = issue.title
            cell.createdByLabel.text = "Created by \(issue.postedBy.name)"
            cell.checkmarkLabel.text = issue.open ? "open" : "closed"
        }.addDisposableTo(disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
