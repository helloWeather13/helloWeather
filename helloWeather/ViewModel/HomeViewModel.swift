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
    var currentSearchModel : SearchModel? {
        didSet{
            if currentSearchModel?.city != "" || currentSearchModel?.fullAddress != ""{
                self.getCurrentWeather()
            }
        }
    }
    var bookMarkSearchModel : [SearchModel] = []
    var isBookmarked = false {
        didSet {
            bookMarkDidChanged(isBookmarked)
        }
    }
    var isNotified = false {
        didSet {
            notfiedDiDChanged(isNotified)
        }
    }
    var isNotification = false
    var userLocationAddress: String? {
        didSet {
            addressOnCompleted(userLocationAddress!)
        }
    }
    var notfiedDiDChanged : ((Bool) -> ()) = { _ in }
    var bookMarkDidChanged: ((Bool) -> ()) = { _ in }
    var addressOnCompleted: ((String) -> ()) = { _ in }
    
    var userLocationPoint: (Double, Double) = (0, 0) {
        didSet {
            let dispatchGroup = DispatchGroup()
            let currentTime = DateFormatter()
            currentTime.dateFormat = "HH"
            let currentHour = Int(currentTime.string(from: Date()))!
            if self.currentSearchModel == nil {
                self.currentSearchModel = SearchModel(keyWord: "", fullAddress: "" , lat: userLocationPoint.0, lon: userLocationPoint.1, city: "")
            }
           
            dispatchGroup.enter()
            webServiceManager.getForecastWeather(searchModel: self.currentSearchModel!) { [unowned self] data in
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
            webServiceManager.getHistoryWeather(searchModel: self.currentSearchModel!) { [unowned self] data in
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
        loadCurrentBookMark()
        userLocationManager.delegate = self
        userLocationManager.distanceFilter = kCLDistanceFilterNone
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        userLocationManager.requestWhenInUseAuthorization()
        userLocationManager.startUpdatingLocation()
        getUserLocation()
        userLocationManager.stopUpdatingLocation()
        
    }
    
    func getCurrentWeather(){
        userLocationAddress = self.currentSearchModel?.fullAddress ?? ""
        userLocationPoint = (self.currentSearchModel?.lat ?? 0 , self.currentSearchModel?.lon ?? 0)
        self.isBookmarked = self.isCurrentLocationBookMarked()
        loadNotification()
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
                    self.currentSearchModel = SearchModel(keyWord: "", fullAddress: address, lat: x, lon: y, city: address)
                    userLocationPoint = (x, y)
                    self.isBookmarked = self.isCurrentLocationBookMarked()
                    loadNotification()
                } else {
                    print("No location")
                }
            }
        }
    }
    
    func saveCurrentBookMark() {
        if !isCurrentLocationBookMarked() {
            bookMarkSearchModel.append(currentSearchModel!)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(bookMarkSearchModel){
                UserDefaults.standard.setValue(encoded, forKey: "bookMark")
            }
        }
    }

    // MARK: - loadRecentSearch UserDefault에 최근 검색 결과 로드
    func loadCurrentBookMark(){
        if let savedData = UserDefaults.standard.object(forKey: "bookMark") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([SearchModel].self, from: savedData) {
                self.bookMarkSearchModel = savedObject
            }
        }
    }
    func isCurrentLocationBookMarked() -> Bool{
        if let currentSearchModel {
            if self.bookMarkSearchModel.contains(where: {
                $0.fullAddress == currentSearchModel.fullAddress
            }){
                return true
            }else{
                return false
            }
        }
        return false
    }
    
    func loadNotification(){
        if let currentSearchModel {
            if isCurrentLocationBookMarked(){
                self.isNotified = currentSearchModel.notification
            }
        }
    }

    
    // MARK: - deleteRecentSearch UserDefault에서 최근 결과 삭제
    func deleteCurrentBookMark(){
        guard let index = bookMarkSearchModel.firstIndex(where: {
            $0.fullAddress == currentSearchModel?.fullAddress
        }) else {return}
        bookMarkSearchModel.remove(at: index)
        isBookmarked = false
        isNotified = false
//        UserDefaults.standard.removeObject(forKey: "bookMark")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(bookMarkSearchModel){
            UserDefaults.standard.setValue(encoded, forKey: "bookMark")
        }
        
    }
    
    func changeNotiCurrentBookMark(){
        self.isNotified = !isNotified
        guard let index = bookMarkSearchModel.firstIndex(where: {
            $0.fullAddress == currentSearchModel?.fullAddress
        }) else {return}
        bookMarkSearchModel[index].notification = isNotified
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(bookMarkSearchModel){
            UserDefaults.standard.setValue(encoded, forKey: "bookMark")
        }
    }
    
    
}
