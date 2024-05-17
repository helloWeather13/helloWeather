//
//  HomeViewModel.swift
//  helloWeather
//
//  Created by CaliaPark on 5/15/24.
//

import UIKit
import CoreLocation

enum ConditionText: String {
    case rain = "비 소식"
    case snow = "눈 소식"
    case none = "맑은 날"
    
    var detail: (icon: UIImage, verb: String) {
        switch self {
        case .rain:
            return (UIImage(systemName: "sun.min")!, "이 있어요")
        case .snow:
            return (UIImage(systemName: "sun.min")!, "이 있어요")
        case .none:
            return (UIImage(systemName: "sun.min")!, "이에요")
        }
    }
    
    var icon: UIImage {
        return detail.icon
    }
    
    var verb: String {
        return detail.verb
    }
}

class HomeViewModel: NSObject, CLLocationManagerDelegate {
    
    let webServiceManager = WebServiceManager.shared
    let userLocationManager = CLLocationManager()
    
    var isBookmarked = false
    
    var userLocationAddress: String = "" {
        didSet {
            addressOnCompleted(userLocationAddress)
        }
    }
    
    var addressOnCompleted: ((String) -> ()) = { _ in }
    
    var userLocationPoint: (Double, Double) = (0, 0) {
        didSet {
            getWeatherData()
        }
    }
    
    var todayFeelsLike: Double = 0
    var yesterdayFeelsLike: Double = 0
    
    var difference: Double = 0 {
        didSet {
            differenceOnCompleted(difference)
        }
    }
    
    var differenceOnCompleted: ((Double) -> ()) = { _ in }
    
    var yesterdayString: String {
        switch difference {
        case 0:
            return "어제와 "
        default:
            return "어제보다 "
        }
    }
    
    var compareDescription: (String, UIImage) {
        switch difference {
        case ..<0:
            switch todayFeelsLike {
            case ..<10:
                return ("춥고", UIImage(systemName: "thermometer.sun")!)
            default:
                return ("선선하고", UIImage(systemName: "thermometer.sun")!)
            }
        case 0:
            return ("비슷하고", UIImage(systemName: "thermometer.sun")!)
        default:
            switch todayFeelsLike {
            case ..<24:
                return ("따뜻하고", UIImage(systemName: "thermometer.sun")!)
            default:
                return ("덥고", UIImage(systemName: "thermometer.sun")!)
            }
        }
    }
    
    var condition: ConditionText = .none {
        didSet {
            conditionOnCompleted()
        }
    }
    
    var conditionOnCompleted: (() -> ()) = { }
    
    var sunriseTime: String = ""
    var sunsetTime: String = ""
    
    var sunriseNum: Int = 0
    var sunsetNum: Int = 0
    
    var sunTimeSplit: Int = 0 {
        didSet {
            sunTimeSplitOnCompleted()
        }
    }
    var sunTimeSplitOnCompleted: (() -> ()) = { }
    
    var nextSunriseTime: String = ""
    var estimated = 0
    var sunriseInfoString: String {
        switch estimated {
        case ..<0:
            return "내일은 오늘보다 \(-estimated)분 일찍 해가 뜰 예정이에요"
        case 0:
            return "내일도 오늘과 같은 시간에 해가 뜰 예정이에요"
        default:
            return "내일은 오늘보다 \(estimated)분 늦게 해가 뜰 예정이에요"
        }
    }
    
    var now: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let formatted = dateFormatter.string(from: Date())
        return timeInMinutes(time: formatted)
    }

    var sunImage: UIImage {
        let index = min((now - sunriseNum) / sunTimeSplit + 1, 10)
        let imageName = "SunRise" + String(format: "%02d", index)
        return UIImage(named: imageName)!
    }
    
    override init() {
        super.init()
        getUserLocation()
    }
    
    func getUserLocation() {
        userLocationManager.delegate = self
        userLocationManager.distanceFilter = kCLDistanceFilterNone
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        userLocationManager.requestWhenInUseAuthorization()
        userLocationManager.startUpdatingLocation()
        
        let geocoder = CLGeocoder()
        let location = self.userLocationManager.location
        
        if let location = location {
            geocoder.reverseGeocodeLocation(location) { [unowned self] (placemarks, error) in
                if error != nil { return }
                
                if let placemark = placemarks?.first {
    
                    let x = placemark.location?.coordinate.latitude ?? 0
                    let y = placemark.location?.coordinate.longitude ?? 0
                    userLocationPoint = (x, y)
                    
                    var address = ""

                    if let administrativeArea = placemark.administrativeArea {
                        address += "\(administrativeArea) "
                    }
                    
                    if let subAdministrativeArea = placemark.subAdministrativeArea {
                        address += "\(subAdministrativeArea) "
                    }
                    
                    if let subLocality = placemark.subLocality {
                        address += "\(subLocality)"
                    }
                    userLocationAddress = address
                } else {
                    print("No location")
                }
            }
        }
        userLocationManager.stopUpdatingLocation()
    }
    
    func getWeatherData() {
        let dispatchGroup = DispatchGroup()
        let currentTime = DateFormatter()
        currentTime.dateFormat = "HH"
        let currentHour = Int(currentTime.string(from: Date()))!
        
        dispatchGroup.enter()
        webServiceManager.getForecastWeather(searchModel: SearchModel(keyWord: "", fullAddress: "", lat: userLocationPoint.0, lon: userLocationPoint.1, city: "")) { [unowned self] data in
            if let currentData = data.current {
                todayFeelsLike = currentData.feelslikeC
            }
            
            let forecastData = data.forecast.forecastday[0]
            
            if forecastData.hour[currentHour].willItRain == 1 {
                condition = .rain
            } else if forecastData.hour[currentHour].willItSnow == 1 {
                condition = .snow
            } else {
                condition = .none
            }
            
            sunriseTime = forecastData.astro.sunrise
            sunsetTime = forecastData.astro.sunset
            nextSunriseTime = data.forecast.forecastday[1].astro.sunrise
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        webServiceManager.getHistoryWeather(searchModel: SearchModel(keyWord: "", fullAddress: "", lat: userLocationPoint.0, lon: userLocationPoint.1, city: "")) { [unowned self] data in
            let currentData = data.forecast.forecastday[0].hour[currentHour]
            yesterdayFeelsLike = currentData.feelslikeC
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [unowned self] in
            difference = todayFeelsLike - yesterdayFeelsLike
            
            sunTimeSplit = getTimeDifference(from: sunriseTime, to: sunsetTime) / 10
            estimated = getTimeDifference(from: sunriseTime, to: nextSunriseTime)
        }
    }
    
    func getTimeDifference(from start: String, to end: String) -> Int {
        let startMinutes = timeInMinutes(time: start)
        let endMinutes = timeInMinutes(time: end)
        return endMinutes - startMinutes
    }
    
    func timeInMinutes(time: String) -> Int {
        let components = time.split(separator: ":")
        let hour = Int(components[0]) ?? 0
        let minute = Int(components[1].prefix(2)) ?? 0
        let isPM = time.contains("PM")
        return ((isPM ? 12 : 0) + hour) * 60 + minute
    }
}
