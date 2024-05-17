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
        
        if let rainyImage = UIImage(named: "rainy") {
            weatherIconTestData = Array(repeating: rainyImage, count: weekTest.count)
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
        cell.minCelsiusLabel.text = "\(minCelsiusTest[indexPath.item])°"
        cell.maxCelsiusLabel.text = "\(maxCelsiusTest[indexPath.item])°"
        
        
        if indexPath.item < weatherIconTestData.count {
            cell.weatherIcon.image = weatherIconTestData[indexPath.item]
        }
        
        if indexPath.item == 0 {
            cell.weekLabel.textColor = .black
            cell.weekLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
            cell.dateLabel.textColor = .black
            cell.dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            cell.minCelsiusLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            cell.maxCelsiusLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        } else {
            cell.weekLabel.textColor = .darkGray
            cell.weekLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            cell.dateLabel.textColor = .darkGray
            cell.dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.minCelsiusLabel.textColor = .darkGray
            cell.minCelsiusLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.maxCelsiusLabel.textColor = .darkGray
            cell.maxCelsiusLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        }
        
        if weekTest[indexPath.item] == "토" || weekTest[indexPath.item] == "일" {
            cell.weekLabel.textColor = .red
            cell.dateLabel.textColor = .red
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 38
        let height: CGFloat = 173
        return CGSize(width: width, height: height)
    }
    
    
}