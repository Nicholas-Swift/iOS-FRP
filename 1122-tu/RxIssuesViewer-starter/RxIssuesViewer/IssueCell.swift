//
//  IssueCell.swift
//  RxIssuesViewer
//
//  Created by Nicholas Swift on 12/1/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class IssueCell: UITableViewCell {
    
    // Variables
    var disposeBag = DisposeBag()
    var avatarString: String? {
        didSet {
            // Set up image
            let avatarUrl = URL(string: avatarString ?? "")!
            let imageObservable: Observable<UIImage?> = URLSession.shared.rx.data(request: URLRequest(url: avatarUrl)).map { (data: Data) in
                return UIImage(data: data)
                }.observeOn(MainScheduler.instance).catchErrorJustReturn(nil)
            
            imageObservable.bindTo(profileImageView.rx.image).addDisposableTo(self.disposeBag)
        }
    }
    
    // UI Elements
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var issueTitleLabel: UILabel!
    @IBOutlet weak var createdByLabel: UILabel!
    @IBOutlet weak var checkmarkLabel: UILabel!
    
    override func prepareForReuse() {
        
    }
}

