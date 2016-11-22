//
//  TodaysWeatherViewController.swift
//  RxOpenWeather
//
//  Created by Nikolas Burk on 17/11/16.
//  Copyright © 2016 Nikolas Burk. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodaysWeatherViewController: UIViewController {
    
    // UI Elements
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var forecastButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var avgTemperatureLabel: UILabel!
    
    // Variables
    var openWeatherMapAPI = RxOpenWeatherMapAPI()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create weatherObservable
        let weatherObservable: Observable<Weather?> = cityTextField.rx.text.asObservable().throttle(0.75, scheduler: MainScheduler.instance).flatMapLatest { (text: String?) in
            return self.openWeatherMapAPI.createWeatherObservable(for: text!)
        }
        
        // Description
        weatherObservable.map { (weather: Weather?) in
            if let weather = weather {
                return weather.description
            }
            return "-"
        }.bindTo(descriptionLabel.rx.text)
        .addDisposableTo(disposeBag)
        
        // Min
        weatherObservable.map { (weather: Weather?) in
            if let weather = weather {
                return String(weather.temperature.min)
            }
            return "-"
            }.bindTo(minTemperatureLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        // Max
        weatherObservable.map { (weather: Weather?) in
            if let weather = weather {
                return String(weather.temperature.max)
            }
            return "-"
            }.bindTo(maxTemperatureLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        // Avg
        weatherObservable.map { (weather: Weather?) in
            if let weather = weather {
                return String(weather.temperature.avg)
            }
            return "-"
            }.bindTo(avgTemperatureLabel.rx.text)
            .addDisposableTo(disposeBag)
        
        // Forecast button
        weatherObservable.map { (weather: Weather?) in
            return weather != nil
        }.bindTo(forecastButton.rx.isEnabled).addDisposableTo(disposeBag)
        
        
    }
    
    
}

