//
//  TodayTimeWeatherCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit

class TodayTimeWeatherCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    init() {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
           
           self.delegate = self
           self.dataSource = self
           self.register(SecondLeftCollectionViewCell.self, forCellWithReuseIdentifier: SecondLeftCollectionViewCell.identifier)
            self.showsHorizontalScrollIndicator = false
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SecondLeftCollectionViewCell.identifier, for: indexPath) as! SecondLeftCollectionViewCell
        
        cell.celsiusLabel.text = "\(indexPath.item * 5)°C"
        
        let hour = (indexPath.item * 3) % 24
        cell.timeLabel.text = "\(hour)시"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 40
        let height: CGFloat = 146
        return CGSize(width: width, height: height)
    }

}
