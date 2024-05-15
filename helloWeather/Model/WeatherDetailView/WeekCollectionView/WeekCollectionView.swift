//
//  WeekCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit

class WeekCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var weekTest: [String] = ["오늘", "화", "수", "목", "금", "토", "일"]
    var dateTest: [String] = ["5.13", "5.14", "5.15", "5.16", "5.17"]
    var minCelsiusTest: [String] = ["17", "17", "17", "17", "17"]
    var maxCelsiusTest: [String] = ["17", "17", "17", "17", "17"]
    var weatherIconTestData: [UIImage] = []
    
    init() {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
           
           self.delegate = self
           self.dataSource = self
           self.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: WeekCollectionViewCell.identifier)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekTest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.identifier, for: indexPath) as! WeekCollectionViewCell
        
        let weekTestData = weekTest[indexPath.item]
        cell.weekLabel.text = weekTestData
        
        let dateTestData = dateTest[indexPath.item]
        cell.dateLabel.text = dateTestData
        
        let minCelsiusTestData = minCelsiusTest[indexPath.item]
        cell.minCelsiusLabel.text = minCelsiusTestData
        
        let maxCelsiusTestData = minCelsiusTest[indexPath.item]
        cell.maxCelsiusLabel.text = maxCelsiusTestData
        
        let rainyImage = UIImage(named: "rainy")
        weatherIconTestData.append(rainyImage!)
        let weatherIconData = weatherIconTestData[indexPath.item]
        cell.weatherIcon.image = weatherIconData
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 36
        let height: CGFloat = 146
        return CGSize(width: width, height: height)
    }
   

}
