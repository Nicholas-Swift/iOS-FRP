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
    var issues: Variable<[Issue]> = Variable([])
    
    // UI Elements
    
    @IBOutlet weak var tableView: UITableView!
    
    // View Controller
    
    func openUrl(indexPath: IndexPath) {
        let issue = issues.value[indexPath.row]
        let url = URL(string: "\(issue.url)")!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
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
        
        // Bind to variable
        issuesObservable.bindTo(issues).addDisposableTo(disposeBag)
        
        // Set up table view
        issuesObservable.bindTo(tableView.rx.items(cellIdentifier: "IssueCell", cellType: IssueCell.self)) { (index: Int, issue: Issue, cell: IssueCell) in
            cell.issueTitleLabel.text = issue.title
            cell.createdByLabel.text = "\(issue.postedBy.login)"
            cell.checkmarkLabel.text = issue.open ? "🔥" : "✅"
            cell.avatarString = issue.postedBy.avatarUrl
            
//            // Set up image
//            let avatarUrl = URL(string: issue.postedBy.avatarUrl)!
//            let imageObservable: Observable<UIImage?> = URLSession.shared.rx.data(request: URLRequest(url: avatarUrl)).map { (data: Data) in
//                return UIImage(data: data)
//            }.observeOn(MainScheduler.instance).catchErrorJustReturn(nil)
//            imageObservable.bindTo(cell.profileImageView.rx.image).addDisposableTo(self.disposeBag)
            
        }.addDisposableTo(disposeBag)
        tableView.rowHeight = 120
        
        // Set up table view cell tapped
        tableView.rx.itemSelected.subscribe(onNext: openUrl).addDisposableTo(disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
