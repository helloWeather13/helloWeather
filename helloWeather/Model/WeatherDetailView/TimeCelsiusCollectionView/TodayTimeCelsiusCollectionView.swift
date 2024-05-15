//
//  TimeCelsiusCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit

class TodayTimeCelsiusCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var celsiusTest: [String] = ["17", "21", "22", "21", "20"]
    var timeTest: [String] = ["지금", "3시", "6시", "9시", "12시"]
    
    init() {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
           
           self.delegate = self
           self.dataSource = self
           self.register(FirstLeftCollectionViewCell.self, forCellWithReuseIdentifier: FirstLeftCollectionViewCell.identifier)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return celsiusTest.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: FirstLeftCollectionViewCell.identifier, for: indexPath) as! FirstLeftCollectionViewCell
        
        let celsiusTestData = celsiusTest[indexPath.item]
        cell.celsiusLabel.text = celsiusTestData
        
        let timeTestData = timeTest[indexPath.item]
        cell.timeLabel.text = timeTestData
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 36
        let height: CGFloat = 146
        return CGSize(width: width, height: height)
    }
    
    
    
    
}
