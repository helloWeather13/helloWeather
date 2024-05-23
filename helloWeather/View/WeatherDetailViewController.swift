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
        
        self.view.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        let weatherDetailView = WeatherDetailView(frame: self.view.bounds)
        self.view = weatherDetailView
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.view.subviews.forEach { $0.removeFromSuperview() }
            
            let weatherDetailView = WeatherDetailView(frame: self.view.bounds)
            self.view.addSubview(weatherDetailView)
        }
    
}
