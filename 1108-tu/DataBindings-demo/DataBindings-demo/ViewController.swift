//
//  ViewController.swift
//  DataBindings-demo
//
//  Created by Nikolas Burk on 07/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum DataToUpdate: String {
    case name = "Name"
    case age = "Age"
}

class ViewController: UIViewController {
    
    // Set up variables
    var disposeBag = DisposeBag()
    let name: Variable<String> = Variable("Johnny")
    let age: Variable<Int> = Variable(17)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up bindings
        name.asObservable()
            .bindTo(nameLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        age.asObservable()
            .map{String($0)}
            .bindTo(ageLabel.rx.text)
            .addDisposableTo(disposeBag)
        
    }
    
    @IBAction func changeNameButtonPressed(_ sender: AnyObject) {
        showAlertController(dataToUpdate: .name)
    }
    
    @IBAction func changeAgeButtonPressed(_ sender: AnyObject) {
        showAlertController(dataToUpdate: .age)
    }
    
    func showAlertController(dataToUpdate: DataToUpdate) {
        let title = "Update \(dataToUpdate.rawValue)"
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            if let newValue = alert.textFields?.first?.text {
                switch dataToUpdate {
                case .age:
                    self.age.value = Int(newValue)!
                case .name:
                    self.name.value = newValue
                }
            }
        }
        alert.addAction(okAction)
        alert.addTextField() { textField in
            switch dataToUpdate {
            case .age: textField.keyboardType = .numberPad
            default: break
            }
        }
        present(alert, animated: true)
    }
    
}

