//
//  TomorrowTimeWeatherCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class TomorrowTimeWeatherCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private var viewModel: WeatherDetailViewModel?
    private var disposeBag = DisposeBag()
    private var hourlyWeatherData: [WeatherDetailViewModel.HourlyWeather] = []
    
    weak var todayCollectionView: TodayTimeWeatherCollectionView?
    
    init(viewModel: WeatherDetailViewModel, todayCollectionView: TodayTimeWeatherCollectionView) {
        self.viewModel = viewModel
        self.todayCollectionView = todayCollectionView
        
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           super.init(frame: .zero, collectionViewLayout: layout)
           
           self.delegate = self
           self.dataSource = self
           self.register(SecondRightCollectionViewCell.self, forCellWithReuseIdentifier: SecondRightCollectionViewCell.identifier)
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
                guard let self = self, let todayCollectionView = self.todayCollectionView else { return }
                
//                print("전체 데이터: \(hourlyWeather)")
                
                // 첫 번째 0시의 인덱스 찾기
                guard let firstZeroHourIndex = hourlyWeather.firstIndex(where: { $0.time.hasPrefix("0시") }) else { return }
                
                // 첫 번째 0시부터 3시간 간격으로 필터링된 시간대 가져오기
                var nextDayHourlyWeather = hourlyWeather[firstZeroHourIndex...].enumerated().compactMap { index, hourlyData in
                    guard index % 3 == 0 else { return nil }
                    return hourlyData
                } as [WeatherDetailViewModel.HourlyWeather]
                
                // TomorrowTimeCelsiusCollectionView 셀 개수 설정
                let todayCellCount = todayCollectionView.hourlyWeatherData.count
                let requiredCellCount = min(8, max(0, 16 - todayCellCount))
                nextDayHourlyWeather = Array(nextDayHourlyWeather.prefix(requiredCellCount))
                
                self.hourlyWeatherData = nextDayHourlyWeather
                self.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel?.temperatureUnitSubject2
            .subscribe(onNext: { [weak self] _ in
                self?.updateCellTemperatureLabels()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - SetupWeatherImage
    
    func setupWeatherImage(data: WeatherDetailViewModel.HourlyWeather , cell: SecondRightCollectionViewCell) {
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
    

    // MARK: - CollectionView 프로토콜
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: SecondRightCollectionViewCell.identifier, for: indexPath) as! SecondRightCollectionViewCell
        
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
            cell.timeLabel.textColor = .myblack
            cell.timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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

    private func updateCellTemperatureLabels() {
        for case let cell as SecondRightCollectionViewCell in self.visibleCells {
            guard let indexPath = self.indexPath(for: cell) else { continue }
            let hourlyWeather = hourlyWeatherData[indexPath.item]
            if let temperatureUnit2 = viewModel?.temperatureUnit2 {
                cell.celsiusLabel.text = (temperatureUnit2 == .celsius) ? hourlyWeather.feelslikeC : hourlyWeather.feelslikeF
            }
        }
    }
}
