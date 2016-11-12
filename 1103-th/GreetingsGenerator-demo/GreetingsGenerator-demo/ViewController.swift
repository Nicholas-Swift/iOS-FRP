
//
//  ViewController.swift
//  DataBindings-demo
//
//  Created by Nikolas Burk on 02/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // Variables
    var buttonText: String = "Hi"
    let disposeBag = DisposeBag()
    
    // UI Elements
    @IBOutlet weak var stateSegmentedControl: UISegmentedControl!
    @IBOutlet weak var greetingsLabel: UILabel!
    @IBOutlet weak var greetingsTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet var greetingButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Segmented Observable
        let segmentedObservable: Observable<Int> = stateSegmentedControl.rx.value.map{ (value: Int) in
            
            switch value {
            case 0:
                for button in self.greetingButtons {
                    button.isEnabled = true
                }
                self.greetingsTextField.isEnabled = false
            case 1:
                for button in self.greetingButtons {
                    button.isEnabled = false
                }
                self.greetingsTextField.isEnabled = true
                break
            default:
                break
            }
            
            return value
        }
        
        // Name Field
        let nameFieldObservable: Observable<String> = nameTextField.rx.text.map{String($0 ?? "")}
        
        // Greeting Text Field
        let greetingTextFieldObservable: Observable<String> = greetingsTextField.rx.text.map{String($0 ?? "")}
        
        // Buttons observable
        let greetingTextButtonObservable: Observable<String> = buttonText
        
        // Combined greeting
        let combinedGreetingObservable: Observable<String> = Observable.combineLatest(segmentedObservable, nameFieldObservable, greetingTextButtonObservable, greetingTextFieldObservable) { (segmentedIndex: Int, nameField: String, greetingButton: String, greetingField: String) in
            switch segmentedIndex {
            case 0: return greetingButton + ", " + nameField
            case 1: return greetingField + ", " + nameField
            default: return ""
            }
        }
        combinedGreetingObservable
            .bindTo(greetingsLabel.rx.text)
            .addDisposableTo(disposeBag)
        
    }
    
    @IBAction func stateChanged(_ sender: UISegmentedControl) {
        
    }
    
    @IBAction func greetingsButtonPressed(_ sender: UIButton) {
        self.buttonText = sender.titleLabel?.text ?? ""
    }
    
}


