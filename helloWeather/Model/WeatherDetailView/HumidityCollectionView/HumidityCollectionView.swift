//
//  HumidityCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class HumidityCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: WeatherDetailViewModel?
    private var disposeBag = DisposeBag()
    private var hourlyWeatherData: [WeatherDetailViewModel.HourlyWeather] = []
    
//    var percentTest: [String] = ["62%", "57%", "53%", "58%", "51%"]
//    var timeTest: [String] = ["지금", "3시", "6시", "9시", "12시"]
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
           
           self.delegate = self
           self.dataSource = self
           self.register(HumidityCollectionViewCell.self, forCellWithReuseIdentifier: HumidityCollectionViewCell.identifier)
        self.isScrollEnabled = false
        
        bindViewModel()
        
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    // MARK: - ViewModel 바인딩
    private func bindViewModel() {
        viewModel?.fetchHourlyWeather()
            .subscribe(onNext: { [weak self] hourlyWeather in
                let now = Calendar.current.component(.hour, from: Date())
                var shouldIncludeNextDay = false
//                var shouldUpdateTomorrow = false
                
                if let lastHour = hourlyWeather.last?.time, lastHour == "21시" {
                    shouldIncludeNextDay = true
//                    shouldUpdateTomorrow = true
                }
                
                self?.hourlyWeatherData = hourlyWeather.filter { hourlyWeather in
                    guard let hour = Int(hourlyWeather.time.replacingOccurrences(of: "시", with: "")) else {
                        return false
                    }
                    
                    // 현재 시간부터 먼저 선택
                    if hour == now {
                        return true
                    }
                    
                    // 3의 배수 시간만 선택
                    if hour % 3 == 0 {
                        return true
                    }
                    
                    // 다음 날의 데이터가 필요한 경우 0시부터의 값을 반환
                    if shouldIncludeNextDay && hour == 0 {
                        return true
                    }
                    
                    return false
                }
                self?.reloadData()

            })
            .disposed(by: disposeBag)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: HumidityCollectionViewCell.identifier, for: indexPath) as! HumidityCollectionViewCell
        
        let hourlyWeather = hourlyWeatherData[indexPath.item]
        
//        let celsiusTestData = percentTest[indexPath.item]
        cell.percentLabel.text = hourlyWeather.humidity
        
//        let timeTestData = timeTest[indexPath.item]
        cell.timeLabel.text = hourlyWeather.time
        
        if indexPath.item == 0 {
            cell.timeLabel.text = "지금"
            cell.timeLabel.textColor = .myblack
            cell.timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
            cell.percentLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
            cell.percentLabel.textColor = .myblack
        } else {
            cell.timeLabel.textColor = .mygray
            cell.percentLabel.textColor = .mygray
            cell.percentLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 47
        let height: CGFloat = 119
        return CGSize(width: width, height: height)
    }
    
    
    
    
}
