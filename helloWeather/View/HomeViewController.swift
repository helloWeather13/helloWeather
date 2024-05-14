//
//  HomeViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import Foundation
import SnapKit
import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tempLabel = UILabel()
        tempLabel.text = "안녕하세요. 그럴싸한 메인 페이지입니다."
        tempLabel.frame = CGRect(x: 50, y: 100, width: 300, height: 30)
        view.addSubview(tempLabel)
    }
}
