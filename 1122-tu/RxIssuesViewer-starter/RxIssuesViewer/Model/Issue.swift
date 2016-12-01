//
//  Issue.swift
//  RxIssuesViewer
//
//  Created by Nikolas Burk on 21/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import Foundation

struct Issue {
    let identifier: Int
    let title: String
    let postedBy: User
    let open: Bool
    let url: String
    
    init(id: Int?, title: String?, postedBy: User?, open: Bool?, url: String?) {
        self.identifier = id ?? 0
        self.title = title ?? "TITLE"
        self.postedBy = postedBy!
        self.open = open ?? false
        self.url = url ?? "www.nicholas-swift.com"
    }
}
