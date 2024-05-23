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
    
    private var viewModel: WeatherDetailViewModel?
    private var disposeBag = DisposeBag()
    var hourlyWeatherData: [WeatherDetailViewModel.HourlyWeather] = []
    
    weak var tomorrowCollectionView: TomorrowTimeCelsiusCollectionView?
    
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
    
    // MARK: - ViewModel 바인딩
    private func bindViewModel() {
        viewModel?.fetchHourlyWeather()
            .subscribe(onNext: { [weak self] hourlyWeather in
                let now = Calendar.current.component(.hour, from: Date())
                var isFirst21Found = false
                
                self?.hourlyWeatherData = hourlyWeather.filter { hourlyData in
                    guard let hour = Int(hourlyData.time.replacingOccurrences(of: "시", with: "")) else {
                        return false
                    }
                    
                    // 첫 번째 21시 이후 값은 버림
                    if !isFirst21Found && hour == 21 {
                        isFirst21Found = true
                        return true // 21시 자신을 포함해서 반환
                    }
                    return !isFirst21Found && hour % 3 == 0
                }
                self?.reloadData()
                self?.updateCollectionViewSize()
            })
            .disposed(by: disposeBag)
        
        viewModel?.temperatureUnitSubject1
            .subscribe(onNext: { [weak self] _ in
                self?.updateCellTemperatureLabels()
            })
            .disposed(by: disposeBag)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: FirstLeftCollectionViewCell.identifier, for: indexPath) as! FirstLeftCollectionViewCell
        
        let hourlyWeather = hourlyWeatherData[indexPath.item]
        let isFirstCell = indexPath.item == 0
        cell.configureConstraints(data: hourlyWeather, isFirstCell: isFirstCell)
        
        // ViewModel에서 현재 온도 단위 가져오기
        let temperatureUnit = viewModel?.temperatureUnit ?? .fahrenheit
        if temperatureUnit == .celsius {
            cell.celsiusLabel.text = hourlyWeather.feelslikeC
        } else {
            cell.celsiusLabel.text = hourlyWeather.feelslikeF
        }
        cell.timeLabel.text = hourlyWeather.time
        
        if indexPath.item == 0 {
            cell.timeLabel.text = "지금"
            cell.timeLabel.textColor = .myblack
            cell.timeLabel.font = UIFont(name: "Pretendard-Semibold", size: 11)
            cell.celsiusLabel.font = UIFont(name: "Pretendard-Semibold", size: 20)
        } else {
            cell.timeLabel.textColor = .mygray
            cell.celsiusLabel.textColor = .mygray
        }
        
        cell.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        
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
    
    private func updateCellTemperatureLabels() {
        for case let cell as FirstLeftCollectionViewCell in self.visibleCells {
            guard let indexPath = self.indexPath(for: cell) else { continue }
            let hourlyWeather = hourlyWeatherData[indexPath.item]
            if let temperatureUnit = viewModel?.temperatureUnit {
                cell.celsiusLabel.text = (temperatureUnit == .celsius) ? hourlyWeather.feelslikeC : hourlyWeather.feelslikeF
            }
        }
    }
    
}
