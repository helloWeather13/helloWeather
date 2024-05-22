//
//  TodayTimeWeatherCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class TodayTimeWeatherCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: WeatherDetailViewModel?
    private var disposeBag = DisposeBag()
    var hourlyWeatherData: [WeatherDetailViewModel.HourlyWeather] = []
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.register(SecondLeftCollectionViewCell.self, forCellWithReuseIdentifier: SecondLeftCollectionViewCell.identifier)
        self.showsHorizontalScrollIndicator = false
            
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
                if let hourlyWeatherData = self?.hourlyWeatherData {
                              print("오늘 날씨 확인: \(hourlyWeatherData)")
                          }
                self?.reloadData()
                self?.updateCollectionViewSize()

            })
            .disposed(by: disposeBag)
        
        viewModel?.temperatureUnitSubject
            .subscribe(onNext: { [weak self] _ in
                self?.updateCellTemperatureLabels()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - SetupWeatherImage
    
    func setupWeatherImage(data: WeatherDetailViewModel.HourlyWeather , cell: SecondLeftCollectionViewCell) {
        switch data.condition  {
        case "맑음", "대체로 맑음", "화창함":
            cell.weatherIcon.image = UIImage(named: "clean")
        case "흐린", "흐림", "구름 낀":
            cell.weatherIcon.image = UIImage(named: "cloudStrong")
        case "안개":
            cell.weatherIcon.image = UIImage(named: "cloud")
        case "짧은 소나기", "가벼운 비":
            cell.weatherIcon.image = UIImage(named: "rainWeak")
        case "보통 비", "근처 곳곳에 비", "비", "소나기":
            cell.weatherIcon.image = UIImage(named: "rainSrong")
        case "폭우":
            cell.weatherIcon.image = UIImage(named: "rainSrong")
        case "낙뢰":
            cell.weatherIcon.image = UIImage(named: "thunder")
        case "뇌우":
            cell.weatherIcon.image = UIImage(named: "storm")
        case "눈":
            cell.weatherIcon.image = UIImage(named: "snow")
        default:
            cell.weatherIcon.image = UIImage(named: "searchImage")
        }
    }
    
    
    
    // MARK: - Collectionview 프로토콜
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SecondLeftCollectionViewCell.identifier, for: indexPath) as! SecondLeftCollectionViewCell
        
        let hourlyWeather = hourlyWeatherData[indexPath.item]
        cell.configureConstraints(data: hourlyWeather)
        
        // ViewModel에서 현재 온도 단위 가져오기
        let temperatureUnit2 = viewModel?.temperatureUnit2 ?? .fahrenheit
        if temperatureUnit2 == .celsius {
            cell.celsiusLabel.text = hourlyWeather.tempC
        } else {
            cell.celsiusLabel.text = hourlyWeather.tempF
        }
        cell.timeLabel.text = hourlyWeather.time
        
        setupWeatherImage(data: hourlyWeather, cell: cell)
        cell.weatherIcon.contentMode = .scaleAspectFit
        
        
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
        let height: CGFloat = 152
        return CGSize(width: width, height: height)
    }
    
    private func updateCollectionViewSize() {
        let itemCount = hourlyWeatherData.count
        let itemWidth: CGFloat = 40
        let totalWidth = ( itemWidth + 10 ) * CGFloat(itemCount)
        
        self.snp.updateConstraints { make in
            make.width.equalTo(totalWidth)
            make.height.equalTo(152)
            make.top.leading.bottom.equalToSuperview()
        }
    }
    
    private func updateCellTemperatureLabels() {
        for case let cell as SecondLeftCollectionViewCell in self.visibleCells {
            guard let indexPath = self.indexPath(for: cell) else { continue }
            let hourlyWeather = hourlyWeatherData[indexPath.item]
            if let temperatureUnit2 = viewModel?.temperatureUnit2 {
                cell.celsiusLabel.text = (temperatureUnit2 == .celsius) ? hourlyWeather.feelslikeC : hourlyWeather.feelslikeF
            }
        }
    }
}
