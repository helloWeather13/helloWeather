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
    
//    var weekTest: [String] = ["오늘", "화", "수", "목", "금", "토", "일"]
//    var dateTest: [String] = ["5.13", "5.14", "5.15", "5.16", "5.17", "5.18", "5.19" ]
//    var minCelsiusTest: [String] = ["17", "17", "17", "17", "17", "17", "17"]
//    var maxCelsiusTest: [String] = ["17", "17", "17", "17", "17", "17", "17"]
    var weatherIconTestNames: [String] = ["rainy"]
    var weatherIconTestData: [UIImage] = []
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.register(WeekCollectionViewCell.self, forCellWithReuseIdentifier: WeekCollectionViewCell.identifier)
        
        if let rainyImage = UIImage(named: "rainy") {
            weatherIconTestData = Array(repeating: rainyImage, count: dailyWeatherData.count)
        }
        
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
                    
                    if let rainyImage = UIImage(named: "rainy") {
                        self?.weatherIconTestData = Array(repeating: rainyImage, count: dailyWeather.count)
                    }
                    
                    self?.reloadData()
                })
                .disposed(by: disposeBag)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyWeatherData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WeekCollectionViewCell.identifier, for: indexPath) as! WeekCollectionViewCell
        
        let dailyWeather = dailyWeatherData[indexPath.item]
        cell.weekLabel.text = dailyWeather.dayOfWeek
        cell.dateLabel.text = dailyWeather.date
        cell.maxCelsiusLabel.text = dailyWeather.mintempC
        cell.minCelsiusLabel.text = dailyWeather.maxtempC
        
//        cell.weekLabel.text = weekTest[indexPath.item]
//        cell.dateLabel.text = dateTest[indexPath.item]
//        cell.minCelsiusLabel.text = "\(minCelsiusTest[indexPath.item])°"
//        cell.maxCelsiusLabel.text = "\(maxCelsiusTest[indexPath.item])°"
        
        
        if indexPath.item < weatherIconTestData.count {
            cell.weatherIcon.image = weatherIconTestData[indexPath.item]
            cell.weatherIcon.contentMode = .scaleAspectFit
        }
        
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
        
//        if weekTest[indexPath.item] == "토" || weekTest[indexPath.item] == "일" {
//            cell.weekLabel.textColor = .red
//            cell.dateLabel.textColor = .red
//        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width: CGFloat = 38
        let height: CGFloat = 173
        return CGSize(width: width, height: height)
    }
    
    
}
