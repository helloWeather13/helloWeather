//
//  TodayTimeWeatherCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit

class TodayTimeWeatherCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var weatherIconTestNames: [String] = ["rainy"]
    var weatherIconTestData: [UIImage] = []
    
//    private let gradientLayer: CAGradientLayer = {
//        let layer = CAGradientLayer()
//        layer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
//        layer.startPoint = CGPoint(x: 0.5, y: 0.5)
//        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        return layer
//    }()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.register(SecondLeftCollectionViewCell.self, forCellWithReuseIdentifier: SecondLeftCollectionViewCell.identifier)
        self.showsHorizontalScrollIndicator = false
        
        if let rainyImage = UIImage(named: "rainy") {
            weatherIconTestData = Array(repeating: rainyImage, count: 8)
        }
        
//        self.layer.mask = gradientLayer
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: 393, height: self.bounds.height)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SecondLeftCollectionViewCell.identifier, for: indexPath) as! SecondLeftCollectionViewCell
        
        cell.celsiusLabel.text = "\(indexPath.item * 5)°"
        
        let hour = (indexPath.item * 3) % 24
        cell.timeLabel.text = "\(hour)시"
        
        if indexPath.item < weatherIconTestData.count {
            cell.weatherIcon.image = weatherIconTestData[indexPath.item]
            cell.weatherIcon.contentMode = .scaleAspectFit
        }
        
        if indexPath.item == 0 {
            cell.timeLabel.text = "오늘"
            cell.timeLabel.textColor = .myblack
            cell.timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            cell.celsiusLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        } else {
            cell.timeLabel.textColor = .mygray
            cell.celsiusLabel.textColor = .mygray
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 40
        let height: CGFloat = 152
        return CGSize(width: width, height: height)
    }
    
}
