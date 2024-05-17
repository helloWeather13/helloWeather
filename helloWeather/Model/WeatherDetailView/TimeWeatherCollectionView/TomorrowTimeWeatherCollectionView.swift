//
//  TomorrowTimeWeatherCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit

class TomorrowTimeWeatherCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var weatherIconTestNames: [String] = ["rainy"]
    var weatherIconTestData: [UIImage] = []
    
    init() {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
           
           self.delegate = self
           self.dataSource = self
           self.register(SecondRightCollectionViewCell.self, forCellWithReuseIdentifier: SecondRightCollectionViewCell.identifier)
            self.showsHorizontalScrollIndicator = false
        
        if let rainyImage = UIImage(named: "rainy") {
            weatherIconTestData = Array(repeating: rainyImage, count: 8)
        }
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SecondRightCollectionViewCell.identifier, for: indexPath) as! SecondRightCollectionViewCell
        
        cell.celsiusLabel.text = "\(indexPath.item * 5)°"
        cell.celsiusLabel.textColor = .mygray
        
        let hour = (indexPath.item * 3) % 24
        cell.timeLabel.text = "\(hour)시"
        cell.timeLabel.textColor = .mygray
        
        if indexPath.item < weatherIconTestData.count {
            cell.weatherIcon.image = weatherIconTestData[indexPath.item]
            cell.weatherIcon.contentMode = .scaleAspectFit
        }

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 40
        let height: CGFloat = 152
        return CGSize(width: width, height: height)
    }

}
