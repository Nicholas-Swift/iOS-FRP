//
//  MainViewController.swift
//  RxIssuesViewer
//
//  Created by Nicholas Swift on 11/29/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    // Variables
    
    let githubApi = RxGitHubAPI()
    var disposeBag = DisposeBag()
    
    // UI Elements
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRepositories: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var seeRepositoriesButton: UIButton!
    
    
    // View Controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create user observable
        let userObservable: Observable<User?> = searchTextField.rx.text.asObservable().throttle(0.75, scheduler: MainScheduler.instance).flatMapLatest { (text: String?) in
            return self.githubApi.searchFor(user: text!)
        }
        
        // Hidden
        userObservable.map { (user: User?) in
            return user == nil
        }.bindTo(userView.rx.isHidden).addDisposableTo(disposeBag)
        
        // Name
        userObservable.map { (user: User?) in
            return user?.name ?? ""
        }.bindTo(userName.rx.text).addDisposableTo(disposeBag)
        
        // Repos
        userObservable.map { (user: User?) in
            let publicRepos = user?.publicRepos ?? 0
            return String(publicRepos)
        }.bindTo(userRepositories.rx.text).addDisposableTo(disposeBag)
        
        // Image
        userObservable.map { (user: User?) in
            if user?.type == "User" {
                return UIImage(named: "user")!
            }
            else {
                return UIImage(named: "org")!
            }
        }.bindTo(userImageView.rx.image).addDisposableTo(disposeBag)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
