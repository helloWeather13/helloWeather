//
//  WeekCollectionView.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class WeekCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var viewModel: WeatherDetailViewModel?
    private var disposeBag = DisposeBag()
    private var dailyWeatherData: [WeatherDetailViewModel.DailyWeather] = []
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: WeekCollectionViewCell.identifier)
        
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewModel 바인딩
    private func bindViewModel() {
        viewModel?.fetchDailyWeather()
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] dailyWeather in
                    self?.dailyWeatherData = dailyWeather
                    self?.reloadData()
                })
                .disposed(by: disposeBag)
        
        viewModel?.temperatureUnitSubject3
            .subscribe(onNext: { [weak self] _ in
                self?.updateCellTemperatureLabels()
            })
            .disposed(by: disposeBag)
        }
    
    // MARK: - SetupWeatherImage
    
    func setupWeatherImage(data: WeatherDetailViewModel.DailyWeather , cell: WeekCollectionViewCell) {
        switch data.conditionText  {
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.identifier, for: indexPath) as! WeekCollectionViewCell
        
        let dailyWeather = dailyWeatherData[indexPath.item]
        let isFirstCell = indexPath.item == 0
        cell.configureConstraints(data: dailyWeather, isFirstCell: isFirstCell)
        
        cell.weekLabel.text = dailyWeather.dayOfWeek
        cell.dateLabel.text = dailyWeather.date
        
        // ViewModel에서 현재 온도 단위 가져오기
        let temperatureUnit3 = viewModel?.temperatureUnit3 ?? .fahrenheit
        if temperatureUnit3 == .celsius {
            cell.maxCelsiusLabel.text = dailyWeather.mintempC
            cell.minCelsiusLabel.text = dailyWeather.maxtempC
        } else {
            cell.maxCelsiusLabel.text = dailyWeather.mintempF
            cell.minCelsiusLabel.text = dailyWeather.maxtempF
        }
          
        setupWeatherImage(data: dailyWeather, cell: cell)
        cell.weatherIcon.contentMode = .scaleAspectFit

        
        if indexPath.item == 0 {
            cell.weekLabel.textColor = .myblack
            cell.weekLabel.text = "오늘"
            cell.weekLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
            cell.dateLabel.textColor = .myblack
            cell.dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            cell.minCelsiusLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            cell.maxCelsiusLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        } else {
            cell.weekLabel.textColor = .mygray
            cell.weekLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
            cell.dateLabel.textColor = .mygray
            cell.dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.minCelsiusLabel.textColor = .mygray
            cell.minCelsiusLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
            cell.maxCelsiusLabel.textColor = .mygray
            cell.maxCelsiusLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        }
        
        if cell.weekLabel.text == "토" || cell.weekLabel.text == "일" {
            cell.weekLabel.textColor = .myred
            cell.dateLabel.textColor = .myred
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 38
        let height: CGFloat = 173
        return CGSize(width: width, height: height)
    }
    
    private func updateCellTemperatureLabels() {
        for case let cell as WeekCollectionViewCell in self.visibleCells {
            guard let indexPath = self.indexPath(for: cell) else { continue }
            let dailyWeather = dailyWeatherData[indexPath.item]
            if let temperatureUnit3 = viewModel?.temperatureUnit3 {
                cell.maxCelsiusLabel.text = (temperatureUnit3 == .celsius) ? dailyWeather.mintempC : dailyWeather.mintempF
                cell.minCelsiusLabel.text = (temperatureUnit3 == .celsius) ? dailyWeather.maxtempC :
                dailyWeather.maxtempF
            }
        }
    }
    
}
