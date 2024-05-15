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
        
        let weatherDetailView = WeatherDetailView(frame: self.view.bounds)
        
        // WeatherDetailView를 WeatherDetailViewController의 뷰로 설정
        self.view = weatherDetailView
    }
    
    
}
