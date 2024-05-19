//
//  WeatherDetailViewModel.swift
//  helloWeather
//
//  Created by 이유진 on 5/18/24.
//

import Foundation
import RxSwift
import RxCocoa

class WeatherDetailViewModel {
    
    // 트리거: 변환 시 호출 (Delegate 역할)
    struct Input {
        let fetchWeatherTrigger = PublishSubject<Void>()
    }
    
    // 전달데이터
    struct Output {
        let hourlyWeather: Observable<[HourlyWeather]> // 시간별 날씨 정보
    }
    
    struct HourlyWeather {
        let time: String // 시간
        let feelslikeC: String // 체감온도 (Celsius)
        let feelslikeF: String
        let tempC: String // 온도 (Celsius)
        let tempF: String
        let humidity: String
    }
    
    private let weatherManager: WebServiceManager
    private let userLocationPoint: (Double, Double)
    private var disposeBag = DisposeBag()
    
    // 다른 파일에서 인스턴스 생성할 때 실행되는 내용들
    init(weatherManager: WebServiceManager, userLocationPoint: (Double, Double)) {
        self.weatherManager = weatherManager
        self.userLocationPoint = userLocationPoint
    }
    
    // 시간별 날씨 정보 가져오기
    func fetchHourlyWeather() -> Observable<[HourlyWeather]> {
        let location = SearchModel(keyWord: "", fullAddress: "", lat: userLocationPoint.0, lon: userLocationPoint.1, city: "")
        
        return Observable.create { observer in
            self.weatherManager.getForecastWeather(searchModel: location) { data in
                if let hourlyData = data.forecast.forecastday.first?.hour.prefix(27) {
                    let currentHour = Calendar.current.component(.hour, from: Date())
                    let hourlyWeather = hourlyData.enumerated().map { index, hourlyData in
                        let hour = (currentHour + index) % 24 // 현재 시간에 인덱스를 더한 값 (24시간 기준)
                        let formattedHour = "\(hour)시"
                        return HourlyWeather(time: formattedHour, feelslikeC: "\(hourlyData.feelslikeC)°", feelslikeF: "\(hourlyData.feelslikeF)°", tempC: "\(hourlyData.tempC)°", tempF: "\(hourlyData.tempF)°", humidity: "\(hourlyData.humidity)%")
                    }
                    observer.onNext(hourlyWeather)
                } else {
                    observer.onNext([])
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
