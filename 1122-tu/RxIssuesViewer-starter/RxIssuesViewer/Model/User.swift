//
//  User.swift
//  RxIssuesViewer
//
//  Created by Nikolas Burk on 21/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation

struct User {
    let identifier: Int
    let login: String
    let name: String
    let email: String
    
    let publicRepos: Int
    let type: String
    
    init(id: Int?, login: String?, name: String?, email: String?, publicRepos: Int?, type: String?) {
        self.identifier = id ?? 0
        self.login = login ?? ""
        self.name = name ?? ""
        self.email = email ?? ""
        self.publicRepos = publicRepos ?? 0
        self.type = type ?? ""
    }
    
}
