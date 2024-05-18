import Foundation
import RxSwift
import RxCocoa

class FineListViewModel: ObservableObject {
    // 트리거
    let fineListTrigger = PublishSubject<Void>()
    // 전달데이터
    @Published var toggle: Bool = false
    @Published var faceType1: Facetype = .smile
    @Published var faceType2: Facetype = .smile
    @Published var faceType3: Facetype = .smile
    @Published var faceType4: Facetype = .smile
    @Published var co: String = "0.063"
    @Published var o3: String = "0.009"
    @Published var so2: String = "0.300"
    @Published var no2: String = "0.003"
    @Published var micro1: String = ""
    @Published var micro2: String = ""
    @Published var micro3: String = ""
    @Published var micro4: String = ""
    @Published var fine1: String = ""
    @Published var fine2: String = ""
    @Published var fine3: String = ""
    @Published var fine4: String = ""
    @Published var location : SearchModel = SearchModel(keyWord: "", fullAddress: "", lat: 0.0, lon: 0.1, city: "")
    
    
    private let weatherManager: WebServiceManager
    private let userLocationPoint: (Double, Double)
    private var disposeBag = DisposeBag()
    
    init(weatherManager: WebServiceManager, userLocationPoint: (Double, Double)) {
        self.weatherManager = weatherManager
        self.userLocationPoint = userLocationPoint
        
        fineListTrigger
            .subscribe(onNext: { [weak self] in
                self?.fetchWeatherData()
            })
            .disposed(by: disposeBag)
    }
    
    func changeToggle() {
        toggle = !toggle
        print(toggle)
        fetchWeatherData()
    }
    
    func dispose() {
        disposeBag = DisposeBag()  // Reset the DisposeBag to cancel all subscriptions
    }
    
    
    
    func getFaceType(for value: Double) -> Facetype {
        switch value {
        case ..<15:
            return .happy
        case ..<35:
            return .smile
        case ..<55:
            return .umm
        default:
            return .bad
        }
    }
    
    func fetchWeatherData() {
        let searchModel = SearchModel(keyWord: "", fullAddress: "", lat: 37.0, lon: 127.1, city: "")
        
        weatherManager.getForecastWeather(searchModel: searchModel) { [unowned self] data in
            guard (data.current != nil) else {
                return
            }
            DispatchQueue.main.async {
                let forecastDays = data.forecast.forecastday.prefix(4)
                
                if let airQuality1 = forecastDays[0].day.airQuality {
                    //print(forecastDays[0].day)
                    self.micro1 = formatToThreeDecimalPlaces(value: airQuality1.fine)
                    self.fine1 = formatToThreeDecimalPlaces(value: airQuality1.micro)
                    self.o3 = formatToThreeDecimalPlaces(value: airQuality1.o3)
                    self.no2 = formatToThreeDecimalPlaces(value: airQuality1.no2)
                    self.so2 = formatToThreeDecimalPlaces(value: airQuality1.so2)
                    self.co = formatToThreeDecimalPlaces(value: airQuality1.co)
                    self.faceType1 = self.toggle ? self.getFaceType(for: airQuality1.micro ?? 0.0) : self.getFaceType(for: airQuality1.fine ?? 0.0)
                }
                
                if let airQuality2 = forecastDays[1].day.airQuality {
                    self.micro2 = formatToThreeDecimalPlaces(value: airQuality2.fine)
                    self.fine2 = formatToThreeDecimalPlaces(value: airQuality2.micro)
                    self.faceType2 = self.toggle ? self.getFaceType(for: airQuality2.micro ?? 0.0) : self.getFaceType(for: airQuality2.fine ?? 0.0)
                }
                
                if let airQuality3 = forecastDays[2].day.airQuality {
                    self.micro3 = formatToThreeDecimalPlaces(value: airQuality3.fine)
                    self.fine3 = formatToThreeDecimalPlaces(value: airQuality3.micro)
                    
                    self.faceType3 = self.toggle ? self.getFaceType(for: airQuality3.micro ?? 0.0) : self.getFaceType(for: airQuality3.fine ?? 0.0)
                    
                }
                
                if let airQuality4 = forecastDays[3].day.airQuality {
                    self.micro4 = formatToThreeDecimalPlaces(value: airQuality4.fine)
                    self.fine4 = formatToThreeDecimalPlaces(value: airQuality4.micro)
                    self.faceType4 = self.toggle ? self.getFaceType(for: airQuality4.micro ?? 0.0) : self.getFaceType(for: airQuality4.fine ?? 0.0)
                    
                }
            }
            
        }
        
    }
}

