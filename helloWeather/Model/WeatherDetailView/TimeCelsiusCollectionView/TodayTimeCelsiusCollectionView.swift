//
//  TimeCelsiusCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import RxSwift
import RxCocoa

class TodayTimeCelsiusCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
            
//    private let gradientLayer: CAGradientLayer = {
//            let layer = CAGradientLayer()
//            layer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
//            layer.startPoint = CGPoint(x: 0.5, y: 0.5)
    //            layer.endPoint = CGPoint(x: 1.0, y: 0.5)
//            return layer
//        }()
    private var viewModel: WeatherDetailViewModel?
    private var disposeBag = DisposeBag()
//    private var feelslikeCData: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
    private var hourlyWeatherData: [WeatherDetailViewModel.HourlyWeather] = []
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
           
           self.delegate = self
           self.dataSource = self
           self.register(FirstLeftCollectionViewCell.self, forCellWithReuseIdentifier: FirstLeftCollectionViewCell.identifier)
            self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
        
        bindViewModel()
        
//        self.layer.mask = gradientLayer
        
       }
    
//    override func layoutSubviews() {
//            super.layoutSubviews()
//            gradientLayer.frame = CGRect(x: 0, y: 0, width: 393, height: self.bounds.height)
//        }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private func bindViewModel() {
        
        viewModel?.fetchHourlyWeather()
                    .subscribe(onNext: { [weak self] hourlyWeather in
                        self?.hourlyWeatherData = hourlyWeather
                        self?.reloadData()
                        self?.updateCollectionViewSize()
                    })
                    .disposed(by: disposeBag)
//        let output = viewModel?.fetchWeather()
//          
//        output?.feelslikeC
//              .bind(to: feelslikeCData)
//              .disposed(by: disposeBag)
//          
//          // 다른 output 속성에 대한 바인딩도 동일하게 수행
      }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: FirstLeftCollectionViewCell.identifier, for: indexPath) as! FirstLeftCollectionViewCell
        
        let hourlyWeather = hourlyWeatherData[indexPath.item]
        cell.celsiusLabel.text = hourlyWeather.feelslikeC
        
        cell.timeLabel.text = hourlyWeather.time
        
//        cell.celsiusLabel.text = feelslikeCData.value
//        cell.celsiusLabel.text = "\(indexPath.item * 5)°"
        
//        let hour = (indexPath.item * 3) % 24
//            cell.timeLabel.text = "\(hour)시"
        
        if indexPath.item == 0 {
            cell.timeLabel.text = "지금"
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
        let height: CGFloat = 119
        return CGSize(width: width, height: height)
    }
    
    private func updateCollectionViewSize() {
            let itemCount = hourlyWeatherData.count
            let itemWidth: CGFloat = 40
            let totalWidth = ( itemWidth + 10 ) * CGFloat(itemCount)
            
            self.snp.updateConstraints { make in
                make.width.equalTo(totalWidth)
                make.height.equalTo(119)
                make.top.leading.bottom.equalToSuperview()
            }
        }
    
    
    
}
