//
//  TimeCelsiusCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit

class TodayTimeCelsiusCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let gradientLayer: CAGradientLayer = {
            let layer = CAGradientLayer()
            layer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
            layer.startPoint = CGPoint(x: 0.9, y: 0.5)
            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
            return layer
        }()
    
    init() {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
           
           self.delegate = self
           self.dataSource = self
           self.register(FirstLeftCollectionViewCell.self, forCellWithReuseIdentifier: FirstLeftCollectionViewCell.identifier)
            self.showsHorizontalScrollIndicator = false
        
        self.layer.mask = gradientLayer
        
       }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            gradientLayer.frame = self.bounds
        }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: FirstLeftCollectionViewCell.identifier, for: indexPath) as! FirstLeftCollectionViewCell
        
        cell.celsiusLabel.text = "\(indexPath.item * 5)°C"
        
        let hour = (indexPath.item * 3) % 24
            cell.timeLabel.text = "\(hour)시"
        
        if indexPath.item == 0 {
            cell.timeLabel.text = "오늘"
            cell.timeLabel.textColor = .black
            cell.timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            cell.celsiusLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        } else {
            cell.timeLabel.textColor = .darkGray
            cell.celsiusLabel.textColor = .darkGray
        }
    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 40
        let height: CGFloat = 146
        return CGSize(width: width, height: height)
    }
    
    
    
    
}
