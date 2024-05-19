//
//  TomorrowTimeCelsiusCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/15/24.
//

import UIKit
import RxSwift
import RxCocoa

class TomorrowTimeCelsiusCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
//    private var viewModel: WeatherDetailViewModel?
//    private var disposeBag = DisposeBag()
    private var hourlyWeatherData: [WeatherDetailViewModel.HourlyWeather] = []
    
    
    init(/*viewModel: WeatherDetailViewModel*/) {
//        self.viewModel = viewModel
        
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
        
           self.delegate = self
           self.dataSource = self
           self.register(FirstRightCollectionViewCell.self, forCellWithReuseIdentifier: FirstRightCollectionViewCell.identifier)
            self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
        
//        bindViewModel()
        
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
//    private func bindViewModel() {
//        viewModel?.fetchHourlyWeather()
//            .subscribe(onNext: { [weak self] hourlyWeather in
//                let now = Calendar.current.component(.hour, from: Date())
//                self?.hourlyWeatherData = hourlyWeather.filter { hourlyWeather in
//                    guard let hour = Int(hourlyWeather.time.replacingOccurrences(of: "시", with: "")) else {
//                        return false
//                    }
//                    // 현재 시간 이후의 값 중에서 0시부터의 값만 반환
//                    return hour >= now || hour == 0
//                }
//                self?.reloadData()
//            })
//            .disposed(by: disposeBag)
//    }
    
    func updateTomorrowData(with hourlyWeather: [WeatherDetailViewModel.HourlyWeather]) {
            let now = Calendar.current.component(.hour, from: Date())
            self.hourlyWeatherData = hourlyWeather.filter { hourlyWeather in
                guard let hour = Int(hourlyWeather.time.replacingOccurrences(of: "시", with: "")) else {
                    return false
                }
                // 현재 시간 이후의 값 중에서 0시부터의 값만 반환
                return hour >= now || hour == 0
            }
            self.reloadData()
        }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: FirstRightCollectionViewCell.identifier, for: indexPath) as! FirstRightCollectionViewCell
        
        let hourlyWeather = hourlyWeatherData[indexPath.item]
        cell.celsiusLabel.text = hourlyWeather.feelslikeC
        cell.timeLabel.text = hourlyWeather.time
//        cell.celsiusLabel.text = "\(indexPath.item * 5)°"
//        cell.celsiusLabel.textColor = .mygray
//        
//        let hour = (indexPath.item * 3) % 24
//        cell.timeLabel.text = "\(hour)시"
        cell.timeLabel.textColor = .mygray
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 40
        let height: CGFloat = 119
        return CGSize(width: width, height: height)
    }

}
