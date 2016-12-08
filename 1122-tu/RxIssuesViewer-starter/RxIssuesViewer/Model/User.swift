//
//  User.swift
//  RxIssuesViewer
//
//  Created by Nikolas Burk on 21/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit

struct User {
    let identifier: Int
    let login: String
    let name: String
    let email: String
    
    let publicRepos: Int
    let type: String
    
    let avatarUrl: String
    
    init(id: Int?, login: String?, name: String?, email: String?, publicRepos: Int?, type: String?, avatarUrl: String?) {
        self.identifier = id ?? 0
        self.login = login ?? ""
        self.name = name ?? ""
        self.email = email ?? ""
        self.publicRepos = publicRepos ?? 0
        self.type = type ?? ""
        self.avatarUrl = avatarUrl ?? ""
    }
    
    init(json: [String: Any]) {
        let id = json["id"] as? Int
        let login = json["login"] as? String
        let name = json["name"] as? String
        let email = json["email"] as? String
        let publicRepos = json["public_repos"] as? Int
        let type = json["type"] as? String
        let avatarUrl = json["avatar_url"] as? String
        
        self.identifier = id ?? 0
        self.login = login ?? ""
        self.name = name ?? ""
        self.email = email ?? ""
        self.publicRepos = publicRepos ?? 0
        self.type = type ?? ""
        self.avatarUrl = avatarUrl ?? ""
    }
    
}
