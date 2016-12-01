//
//  RxGitHubAPI.swift
//  RxIssuesView
//
//  Created by Nikolas Burk on 21/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//
//  inspired by Octokit.swift

import Foundation
import UIKit
import RxSwift
import RxCocoa

class RxGitHubAPI {
    
    static private let clientID = "b5ddb1d98aa21662a427"
    static private let clientSecret = "707c85532d2510d8c071dff60b3d04768edb4fd4"
    static private var userAccessToken = ""
    
    let baseURL = "https://api.github.com"
    static let githubWebURL = "https://github.com"
    
    enum GitHubEndpoint {
        case user(String)
        case organization(String)
        case repos(User)
        case issues(User, Repository)
    }
    
    
    // MARK: Authentication
    
    static func authenticate(with code: String) {
        
        let path = "login/oauth/access_token"
        let params = ["client_id": clientID, "client_secret": clientSecret, "code": code]
        
        let urlString = githubWebURL + "/" + path + "?" + params.toURLArguments()
        
        let url = URL(string: urlString)
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print(#file.lastPathComponent()!, #line, #function, "ERROR: no token, code \(response.statusCode)")
                    return
                } else {
                    if let data = data, let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) as? String {
                        let accessToken = string.retrieveAccessToken()
                        if let accessToken = accessToken {
                            print(#file.lastPathComponent()!, #line, #function, "received access token: \(accessToken)")
                            userAccessToken = accessToken
                            
                            // SEGUE
                            DispatchQueue.main.async {
                                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "MainNavController")
                                UIApplication.shared.delegate?.window??.rootViewController = viewController
                            }
                            
                        }
                        else {
                            print(#file.lastPathComponent()!, #line, #function, "ERROR: could not get access token, code \(response.statusCode)")
                        }
                    }
                    else {
                        print(#file.lastPathComponent()!, #line, #function, "ERROR: could not parse data, code \(response.statusCode)")
                    }
                }
            }
        }
        task.resume()
    }
    
    static func loginURL() -> String {
        let baseURL = "https://github.com/login/oauth/authorize"
        let callback = "rxissuesviewer://success"
        let scope = "user%20repo"
        let urlString = baseURL + "?client_id=\(clientID)&redirect_url=\(callback)&scope=\(scope)" //
        return urlString
    }
    
    
    // MARK: URLs
    
    func url(for endpoint: GitHubEndpoint) -> URL? {
        var urlString = baseURL
        switch endpoint {
        case .user(let username):
            urlString = urlString + "/users/" + username
            if RxGitHubAPI.userAccessToken.characters.count > 0 {
                urlString = urlString + "?access_token=" + RxGitHubAPI.userAccessToken
            }
        case .organization(let organizationName):
            urlString = urlString + "/orgs/" + organizationName
            if RxGitHubAPI.userAccessToken.characters.count > 0 {
                urlString = urlString + "?access_token=" + RxGitHubAPI.userAccessToken
            }
        case .repos(let user):
            urlString = urlString + "/users/" + user.login + "/repos"
            if RxGitHubAPI.userAccessToken.characters.count > 0 {
                urlString = urlString + "?access_token=" + RxGitHubAPI.userAccessToken
            }
        case .issues(let user, let repository):
            urlString = urlString + "/repos/" + user.login + "/" + String(repository.name) + "/issues?state=all"
            if RxGitHubAPI.userAccessToken.characters.count > 0 {
                urlString = urlString + "&access_token=" + RxGitHubAPI.userAccessToken
            }
        }
        return URL(string: urlString)
    }
    
    // MARK: User Search
    
    func searchFor(user: String) -> Observable<User?> {
        
        guard let url = self.url(for: .user(user)) else {
            return Observable.just(nil)
        }
        
        let jsonObservable: Observable<Any> = URLSession.shared.rx.json(url: url)
        
        let userObservable: Observable<User?> = jsonObservable.map { (jsonAny: Any) in
            
            guard let json = jsonAny as? [String: Any] else {
                return nil
            }
            
            let id = json["id"] as? Int
            let login = json["login"] as? String
            let name = json["name"] as? String
            let email = json["email"] as? String
            let publicRepos = json["public_repos"] as? Int
            let type = json["type"] as? String
            
            let user = User(id: id, login: login, name: name, email: email, publicRepos: publicRepos, type: type)
            
            return user
        }.observeOn(MainScheduler.instance).catchErrorJustReturn(nil)
        
        return userObservable
        
    }
    
    // MARK: Repository Search
    
    func searchForRepositoryWith(user: User) -> Observable<[Repository]> {
        
        guard let url = self.url(for: .repos(user)) else {
            return Observable.just([])
        }
        
        let jsonObservable: Observable<Any> = URLSession.shared.rx.json(url: url)
        
        let repositoriesObservable: Observable<[Repository]> = jsonObservable.map { (jsonAny: Any) in
            
            guard let json = jsonAny as? [Any] else {
                print(jsonAny)
                return []
            }
            
            var repositories: [Repository] = []
            for i in json {
                
                let repo = i as! [String: Any]
                
                let id = repo["id"] as? Int
                let language = repo["language"] as? String
                let name = repo["name"] as? String
                let fullName = repo["full_name"] as? String
                
                let repository = Repository(id: id, language: language, name: name, fullName: fullName)
                repositories.append(repository)
            }
            
            return repositories
        }.observeOn(MainScheduler.instance).catchErrorJustReturn([])
        
        
        return repositoriesObservable
    }
    
    // MARK: Issues Search
    
    func searchForIssuesWith(user: User, repository: Repository) -> Observable<[Issue]> {
        
        guard let url = self.url(for: .issues(user, repository)) else {
            return Observable.just([])
        }
        
        let jsonObservable: Observable<Any> = URLSession.shared.rx.json(url: url)
        
        let issuesObservable: Observable<[Issue]> = jsonObservable.map { (jsonAny: Any) in
            
            guard let json = jsonAny as? [Any] else {
                print(jsonAny)
                return []
            }
            
            var issues: [Issue] = []
            for i in json {
                
                let iss = i as! [String: Any]
                
                let id = iss["id"] as? Int
                let title = iss["title"] as? String
                let postedBy = iss["user"] as? [String: Any]
                let postedUser = User(json: postedBy!)
                let open = iss["open"] as? Bool
                let url = iss["url"] as? String
                
                let issue = Issue(id: id, title: title, postedBy: postedUser, open: open, url: url)
                issues.append(issue)
            }
            
            return issues
            }.observeOn(MainScheduler.instance).catchErrorJustReturn([])
        
        
        return issuesObservable
    }
    
}




