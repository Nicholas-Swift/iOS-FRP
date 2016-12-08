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
    
    var repos: Variable<[Repository]> = Variable([])
    var filteredRepos: Variable<[Repository]> = Variable([])
    
    // UI Elements
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // Helper
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! IssuesViewController
        
        destination.user = self.user
        
        let selectedRow = tableView.indexPathForSelectedRow!.row
        destination.repo = repos.value[selectedRow]
    }
    
    func setRepos(repos: [Repository]) {
        self.repos.value = repos
        self.filteredRepos.value = filteredRepos.value.isEmpty ? repos : []
    }
    
    func filterRepos(text: String?) {
        guard let text = text else {
            
            filteredRepos.value = repos.value
            
            return
        }
        
        var newValue: [Repository] = []
        for repo in repos.value {
            if repo.name.hasPrefix(text) {
                newValue.append(repo)
            }
        }
        
        self.filteredRepos.value = newValue
    }
    
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
        
        // Create repo observable
        let repoObservable: Observable<[Repository]> = self.githubApi.searchForRepositoryWith(user: user)
        repoObservable.subscribe(onNext: setRepos).addDisposableTo(disposeBag)
        
        // Create search bar observable
        let searchbarObservable: Observable<String?> = self.searchBar.rx.text.asObservable()
        searchbarObservable.subscribe(onNext: filterRepos).addDisposableTo(disposeBag)
        filterRepos(text: nil)
        
        // Bind to tableView
        filteredRepos.asObservable().bindTo(tableView.rx.items(cellIdentifier: "RepositoriesBasicCell", cellType: UITableViewCell.self)) { (index: Int, repo: Repository, cell: UITableViewCell) in
            cell.textLabel?.text = repo.fullName
        }.addDisposableTo(disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

