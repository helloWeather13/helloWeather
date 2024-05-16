//
//  WeekCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit

class WeekCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var weekTest: [String] = ["오늘", "화", "수", "목", "금", "토", "일"]
    var dateTest: [String] = ["5.13", "5.14", "5.15", "5.16", "5.17", "5.18", "5.19" ]
    var minCelsiusTest: [String] = ["17", "17", "17", "17", "17", "17", "17"]
    var maxCelsiusTest: [String] = ["17", "17", "17", "17", "17", "17", "17"]
    var weatherIconTestNames: [String] = ["rainy"]
    var weatherIconTestData: [UIImage] = []
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: WeekCollectionViewCell.identifier)
        
        for iconName in weatherIconTestNames {
            if let image = UIImage(named: iconName) {
                weatherIconTestData.append(image)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekTest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.identifier, for: indexPath) as! WeekCollectionViewCell
        
        cell.weekLabel.text = weekTest[indexPath.item]
        cell.dateLabel.text = dateTest[indexPath.item]
        cell.minCelsiusLabel.text = minCelsiusTest[indexPath.item]
        cell.maxCelsiusLabel.text = maxCelsiusTest[indexPath.item]
        
        
        if indexPath.item < weatherIconTestData.count {
                    cell.weatherIcon.image = weatherIconTestData[indexPath.item]
            }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 38
        let height: CGFloat = 173
        return CGSize(width: width, height: height)
    }
    
    
}
