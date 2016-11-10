//
//  ViewController.swift
//  RxCalculator
//
//  Created by Nikolas Burk on 09/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    // Variables
    var disposeBag = DisposeBag()
    var calculator = Calculator()
    
    // UI Elements
    @IBOutlet weak var operationSegmentedControl: UISegmentedControl!
    @IBOutlet weak var firstValueTextField: UITextField!
    @IBOutlet weak var secondValueTextField: UITextField!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    // MARK: View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Values
        let firstValueObservable: Observable<Int> = firstValueTextField.rx.text.map{Int($0 ?? "") ?? 0}
        let secondValueObservable: Observable<Int> = secondValueTextField.rx.text.map{Int($0 ?? "") ?? 0}
        
        // Operation
        let operationObservable: Observable<Calculator.Operation> = operationSegmentedControl.rx.value.map{Calculator.Operation(rawValue: $0)!}
        operationObservable
            .map{self.calculator.signs[$0.rawValue]}
            .bindTo(operationLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        // Combine and Calculate!
        let combinedValueObservable: Observable<Int> = Observable.combineLatest(operationObservable, firstValueObservable, secondValueObservable) { (operationValue: Calculator.Operation, firstValue: Int, secondValue: Int) in
            
            switch operationValue {
            case .addition: return self.calculator.add(a: firstValue, b: secondValue)
            case .subtraction: return self.calculator.subtract(a: firstValue, b: secondValue)
            }
            
        }
        combinedValueObservable
            .map{String($0)}
            .bindTo(resultLabel.rx.text)
            .addDisposableTo(disposeBag)
        
    }
    
}

