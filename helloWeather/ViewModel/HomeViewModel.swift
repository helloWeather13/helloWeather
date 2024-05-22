//
//  HomeViewModel.swift
//  helloWeather
//
//  Created by CaliaPark on 5/15/24.
//

import UIKit
import CoreLocation

class HomeViewModel: NSObject, CLLocationManagerDelegate {
    
    let webServiceManager = WebServiceManager.shared
    let userLocationManager = CLLocationManager()
    var currentSearchModel : SearchModel?
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
    var userLocationAddress: String = "" {
        didSet {
            addressOnCompleted(userLocationAddress)
        }
    }
    var notfiedDiDChanged : ((Bool) -> ()) = { _ in }
    var bookMarkDidChanged: ((Bool) -> ()) = { _ in }
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
                return ("춥고", UIImage(named: "temperature-down")!)
            default:
                return ("선선하고", UIImage(named: "temperature-down")!)
            }
        case 0:
            return ("비슷하고", UIImage(named: "temperature-same")!)
        default:
            switch todayFeelsLike {
            case ..<24:
                return ("따뜻하고", UIImage(named: "temperature-up")!)
            default:
                return ("덥고", UIImage(named: "temperature-up")!)
            }
        }
    }
    
    var condition: ConditionText = .none
        
    enum ConditionText: String {
        case rain = "비 소식"
        case snow = "눈 소식"
        case none = "맑은 날"
        
        func detail(sunrise: Int, sunset: Int, now: Int) -> (icon: UIImage, verb: String) {
            switch self {
            case .rain:
                if sunrise < now && now < sunset {
                    return (UIImage(named: "rainSrnog-day")!, "이 있어요")
                } else {
                    return (UIImage(named: "rainSrnog-night")!, "이 있어요")
                }
            case .snow:
                if sunrise < now && now < sunset {
                    return (UIImage(named: "snow-day")!, "이 있어요")
                } else {
                    return (UIImage(named: "snow-night")!, "이 있어요")
                }
            case .none:
                if sunrise < now && now < sunset {
                    return (UIImage(named: "clean-day")!, "이에요")
                } else {
                    return (UIImage(named: "clean-night")!, "이에요")
                }
            }
        }
    }
    
    var sunriseTime: String = ""
    var sunsetTime: String = ""
    
    var sunriseNum: Int = 0
    var sunsetNum: Int = 0
    var sunTimeSplit: Int = 0
    
    var nextSunriseTime: String = ""
    
    var estimated: Int = 0 {
        didSet {
            updateSunriseInfoString()
            updateSunImage()
        }
    }
    
    var sunriseInfoString: String = ""

    func updateSunriseInfoString() {
        switch estimated {
        case ..<0:
            sunriseInfoString = "내일은 오늘보다 \(-estimated)분 일찍 해가 뜰 예정이에요"
        case 0:
            sunriseInfoString = "내일도 오늘과 같은 시간에 해가 뜰 예정이에요"
        default:
            sunriseInfoString = "내일은 오늘보다 \(estimated)분 늦게 해가 뜰 예정이에요"
        }
    }
    
    var sunImage: UIImage = UIImage(named: "SunRise01")! {
        didSet {
            estimatedOnCompleted()
        }
    }

    var estimatedOnCompleted: (() -> ()) = { }

    var now: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let formatted = dateFormatter.string(from: Date())
        return timeInMinutes(time: formatted)
    }

    func updateSunImage() {
        switch now {
        case sunriseNum..<sunriseNum + sunTimeSplit:
            sunImage = UIImage(named: "SunRise02")!
        case sunriseNum + sunTimeSplit..<(sunriseNum + sunTimeSplit * 2):
            sunImage = UIImage(named: "SunRise03")!
        case sunriseNum + sunTimeSplit * 2..<(sunriseNum + sunTimeSplit * 3):
            sunImage = UIImage(named: "SunRise04")!
        case sunriseNum + sunTimeSplit * 3..<(sunriseNum + sunTimeSplit * 4):
            sunImage = UIImage(named: "SunRise05")!
        case sunriseNum + sunTimeSplit * 4..<(sunriseNum + sunTimeSplit * 5):
            sunImage = UIImage(named: "SunRise06")!
        case sunriseNum + sunTimeSplit * 5..<(sunriseNum + sunTimeSplit * 6):
            sunImage = UIImage(named: "SunRise07")!
        case sunriseNum + sunTimeSplit * 6..<(sunriseNum + sunTimeSplit * 7):
            sunImage = UIImage(named: "SunRise08")!
        case sunriseNum + sunTimeSplit * 7..<(sunriseNum + sunTimeSplit * 8):
            sunImage = UIImage(named: "SunRise09")!
        case sunriseNum + sunTimeSplit * 8..<(sunriseNum + sunTimeSplit * 9):
            sunImage = UIImage(named: "SunRise10")!
        default:
            sunImage = UIImage(named: "SunRise01")!
        }
    }
    
    override init() {
        super.init()
        getUserLocation()
        loadCurrentBookMark()
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
                    self.currentSearchModel?.fullAddress = address
                    self.currentSearchModel?.city = address
                    self.isBookmarked = self.isCurrentLocationBookMarked()
                    loadNotification()
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
            
            sunriseNum = timeInMinutes(time: sunriseTime)
            sunsetNum = timeInMinutes(time: sunsetTime)
            
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
            
            sunTimeSplit = getTimeDifference(from: sunriseTime, to: sunsetTime) / 9
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
