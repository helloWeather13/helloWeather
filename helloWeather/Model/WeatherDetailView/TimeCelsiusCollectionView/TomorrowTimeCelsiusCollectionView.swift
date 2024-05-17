//
//  TomorrowTimeCelsiusCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/15/24.
//

import UIKit

class TomorrowTimeCelsiusCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    init() {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
        
           self.delegate = self
           self.dataSource = self
           self.register(FirstRightCollectionViewCell.self, forCellWithReuseIdentifier: FirstRightCollectionViewCell.identifier)
            self.showsHorizontalScrollIndicator = false
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: FirstRightCollectionViewCell.identifier, for: indexPath) as! FirstRightCollectionViewCell
        
        cell.celsiusLabel.text = "\(indexPath.item * 5)°"
        cell.celsiusLabel.textColor = .mygray
        
        let hour = (indexPath.item * 3) % 24
        cell.timeLabel.text = "\(hour)시"
        cell.timeLabel.textColor = .mygray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 40
        let height: CGFloat = 119
        return CGSize(width: width, height: height)
    }

}
