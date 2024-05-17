//
//  WeatherDetailViewController.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit

class WeatherDetailViewController: UIViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let weatherDetailView = WeatherDetailView(frame: self.view.bounds)
        self.view = weatherDetailView
    }
    
    
}
