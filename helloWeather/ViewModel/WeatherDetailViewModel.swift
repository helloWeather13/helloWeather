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
    
    enum TemperatureUnit {
        case celsius
        case fahrenheit
    }
    
    
    // 전달데이터
    struct Output {
        let hourlyWeather: Observable<[HourlyWeather]> // 시간별 날씨 정보
        let dailyWeather: Observable<[DailyWeather]> // 일일 날씨 정보
    }
    
    // 시간별 날씨 정보(체감온도, 날씨, 습도)
    struct HourlyWeather {
        let time: String // 시간
        let feelslikeC: String // 체감온도 (Celsius)
        let feelslikeF: String
        let tempC: String // 온도 (Celsius)
        let tempF: String
        let humidity: String
        let condition: String
    }
    
    // 일일 날씨 정보(요일, 날짜, 온도)
    struct DailyWeather {
        let date: String // 날짜
        let dayOfWeek: String
        let maxtempC: String // 최고온도 (Celsius)
        let maxtempF: String
        let mintempC: String // 최저온도 (Celsius)
        let mintempF: String
        let avgtempC: String // 평균온도 (Celsius)
        let avgtempF: String
        let conditionText: String // 날씨 상태
    }
    
    private let weatherManager: WebServiceManager
    private let userLocationPoint: (Double, Double)
    private var disposeBag = DisposeBag()
    
    var temperatureUnit: TemperatureUnit = .celsius
    var temperatureUnit2: TemperatureUnit = .celsius
    var temperatureUnit3: TemperatureUnit = .celsius
    var flag1: Bool = false
    var flag2: Bool = false
    var flag3: Bool = false
    let temperatureUnitSubject1 = BehaviorSubject<TemperatureUnit>(value: .celsius)
    let temperatureUnitSubject2 = BehaviorSubject<TemperatureUnit>(value: .celsius)
    let temperatureUnitSubject3 = BehaviorSubject<TemperatureUnit>(value: .celsius)
    
    
    
    // 다른 파일에서 인스턴스 생성할 때 실행되는 내용들
    init(weatherManager: WebServiceManager, userLocationPoint: (Double, Double)) {
        self.weatherManager = weatherManager
        self.userLocationPoint = userLocationPoint
    }
    
    func changeToggle(){
        
    }
    
    // 시간별 날씨 정보 가져오기
    func fetchHourlyWeather() -> Observable<[HourlyWeather]> {
        let location = SearchModel(keyWord: "", fullAddress: "", lat: userLocationPoint.0, lon: userLocationPoint.1, city: "")
        
        return Observable.create { observer in
            self.weatherManager.getForecastWeather(searchModel: location) { data in
                let currentHour = Calendar.current.component(.hour, from: Date())
                var hourlyWeather: [HourlyWeather] = []
                
                // 오늘, 내일, 모레의 시간별 날씨 정보 가져오기
                for dayOffset in 0..<3 {
                    if let hourlyData = data.forecast.forecastday[safe: dayOffset]?.hour {
                        for (index, hourlyData) in hourlyData.enumerated() {
                            let hour = (currentHour + index) % 24 // 현재 시간에 인덱스를 더한 값 (24시간 기준)
                            let formattedHour = "\(hour)시"
                            // 온도 정보에서 소수점 뒤의 수를 제외하고 반환
                            let feelslikeCTemperature = Int(hourlyData.feelslikeC)
                            let feelslikeFTemperature = Int(hourlyData.feelslikeF)
                            let tempCTemperature = Int(hourlyData.tempC)
                            let tempFTemperature = Int(hourlyData.tempF)
                            
                            let condition = hourlyData.condition.text
                            
                            let hourlyWeatherData = HourlyWeather(
                                time: formattedHour,
                                feelslikeC: "\(feelslikeCTemperature)°",
                                feelslikeF: "\(feelslikeFTemperature)°",
                                tempC: "\(tempCTemperature)°",
                                tempF: "\(tempFTemperature)°",
                                humidity: "\(hourlyData.humidity)%",
                                condition: "\(condition)"
                            )
                            hourlyWeather.append(hourlyWeatherData)
                        }
                    }
                }
                
                observer.onNext(hourlyWeather)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // 일자별 날씨 정보 가져오기
    func fetchDailyWeather() -> Observable<[DailyWeather]> {
        let location = SearchModel(keyWord: "", fullAddress: "", lat: userLocationPoint.0, lon: userLocationPoint.1, city: "")
        
        return Observable.create { observer in
            self.weatherManager.getForecastWeather(searchModel: location) { data in
                let dailyWeather = data.forecast.forecastday.map { forecastDay in
                    // 수정 시작
                    // 날짜 형식을 "yyyy-MM-dd"에서 "MM.dd"로 변경하여 월과 일만 표시
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    
                    if let date = dateFormatter.date(from: forecastDay.date) {
                        let calendar = Calendar.current
                        let dateFormatterForDate = DateFormatter()
                        dateFormatterForDate.locale = Locale(identifier: "ko_KR")
                        dateFormatterForDate.dateFormat = "MM.dd" // 날짜만 표시
                        
                        let dateFormatterForDay = DateFormatter()
                        dateFormatterForDay.locale = Locale(identifier: "ko_KR")
                        dateFormatterForDay.dateFormat = "E" // 요일만 표시
                        
                        var formattedDate = dateFormatterForDate.string(from: date)
                        let formattedDay = dateFormatterForDay.string(from: date)
                        
                        if formattedDate.hasPrefix("0") {
                            formattedDate = String(formattedDate.dropFirst())
                        }
                        
                        return DailyWeather(
                            date: formattedDate,
                            dayOfWeek: formattedDay,
                            maxtempC: "\(forecastDay.day.maxtempC)°",
                            maxtempF: "\(forecastDay.day.maxtempF)°",
                            mintempC: "\(forecastDay.day.mintempC)°",
                            mintempF: "\(forecastDay.day.mintempF)°",
                            avgtempC: "\(forecastDay.day.avgtempC)°",
                            avgtempF: "\(forecastDay.day.avgtempF)°",
                            conditionText: forecastDay.day.condition.text
                        )
                    }
                    // 오류가 발생할 경우 빈 문자열 반환
                    return DailyWeather(
                        date: "",
                        dayOfWeek: "",
                        maxtempC: "",
                        maxtempF: "",
                        mintempC: "",
                        mintempF: "",
                        avgtempC: "",
                        avgtempF: "",
                        conditionText: ""
                    )
                    // 수정 끝
                }
                
                observer.onNext(dailyWeather)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // 온도 단위 토글
    func toggleTemperatureUnit() {
        temperatureUnit = (temperatureUnit == .celsius) ? .fahrenheit : .celsius
        // 온도 단위 변경을 UI에 알리는 Observable 업데이트
        temperatureUnitSubject1.onNext(temperatureUnit)
    }
    
    func toggleTemperatureUnit2() {
        temperatureUnit2 = (temperatureUnit2 == .celsius) ? .fahrenheit : .celsius
        // 온도 단위 변경을 UI에 알리는 Observable 업데이트
        temperatureUnitSubject2.onNext(temperatureUnit2)
    }
    
    func toggleTemperatureUnit3() {
        temperatureUnit3 = (temperatureUnit3 == .celsius) ? .fahrenheit : .celsius
        // 온도 단위 변경을 UI에 알리는 Observable 업데이트
        temperatureUnitSubject3.onNext(temperatureUnit3)
    }
    
}
