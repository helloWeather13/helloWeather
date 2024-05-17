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
            let dispatchGroup = DispatchGroup()
            let currentTime = DateFormatter()
            currentTime.dateFormat = "HH"
            let currentHour = Int(currentTime.string(from: Date()))!
            
            dispatchGroup.enter()
            webServiceManager.getForecastWeather(searchModel: SearchModel(keyWord: "", fullAddress: "", lat: userLocationPoint.0, lon: userLocationPoint.1, city: "")) { [unowned self] data in
                if let currentData = data.current {
                    todayFeelsLike = currentData.feelslikeC
                }
                
                if data.forecast.forecastday[0].hour[currentHour].willItRain == 1 {
                    condition = .rain
                } else if data.forecast.forecastday[0].hour[currentHour].willItSnow == 1 {
                    condition = .snow
                } else {
                    condition = .none
                }
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
            }
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
    
    override init() {
        super.init()
        userLocationManager.delegate = self
        userLocationManager.distanceFilter = kCLDistanceFilterNone
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        userLocationManager.requestWhenInUseAuthorization()
        userLocationManager.startUpdatingLocation()
        getUserLocation()
        userLocationManager.stopUpdatingLocation()
    }
    
    func getUserLocation() {
        let geocoder = CLGeocoder()
        
        let location = self.userLocationManager.location
        
        if let location = location {
            geocoder.reverseGeocodeLocation(location) { [unowned self] (placemarks, error) in
                if error != nil { return }
                
                if let placemark = placemarks?.first {
    
                    let x = placemark.location?.coordinate.latitude ?? 0
                    let y = placemark.location?.coordinate.longitude ?? 0
                    print(x, y)
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
                    
                    print(address)
                    userLocationAddress = address
                    
                } else {
                    print("No location")
                }
            }
        }
    }
}
