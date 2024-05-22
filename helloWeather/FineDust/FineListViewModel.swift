import Foundation
import SwiftUI
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
    
    @Published var chat1: String = "좋아요!"
    @Published var chat2: String = "아주 좋아요!"
    @Published var chat1Color: Color = Color.green
    @Published var chat2Color: Color = Color.blue
    //미세
    @Published var date1: [Double] = []
    //초미세
    @Published var date2: [Double] = []
    @Published  var colorline: Gradient = Gradient(stops: [
        .init(color: .yellow, location: 0.0),
        .init(color: .yellow, location: 0.1),
        .init(color: .red, location: 0.2),
        .init(color: .red, location: 0.3),
        .init(color: .red, location: 0.4),
        .init(color: .yellow, location: 0.5),
        .init(color: .green, location: 0.6),
        .init(color: .yellow, location: 0.7),
        .init(color: .red, location: 0.8),
        .init(color: .red, location: 0.9),
        .init(color: .red, location: 1.0)
    ])
    @Published var draglocation: CGPoint = CGPoint()
    @Published var draglocation2: CGPoint = CGPoint()
    private var simplifiedValues = [Double]()
    private let weatherManager: WebServiceManager
    private let userLocationPoint: (Double, Double)
    private var disposeBag = DisposeBag()
    private var flag = false
    
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
    
    func returnfine() -> [Double]{
        return date1
    }
    
    func returnmicro() -> [Double]{
        return date2
    }
    
    func dispose() {
        disposeBag = DisposeBag()  // Reset the DisposeBag to cancel all subscriptions
    }
    
    @Published var currentDataNumber: Double = 0 {
        didSet {
            draglocation2.x = draglocation.x - 23
            updateChat1Color()
            updateChat2Color()
            //print("드래그 로케이션1 :", draglocation)
            //print("드래그 로케이션2 :", draglocation2)
        }
    }
    @Published var currentDataNumber2: Double = 0 {
        didSet {
            updateChat1Color()
            updateChat2Color()
            //draglocation2.x = draglocation.x
        }
    }
    private func updateChatColor(input : Double) {
        if input < 20 {
            chat1 = "아주 좋아요!"
            chat1Color = .blue
        } else if input < 30 {
            chat1 = "좋아요!"
            chat1Color = .green
        } else if input < 40 {
            chat1 = "나빠요!"
            chat1Color = .yellow
        } else {
            chat1 = "아주 나빠요!"
            chat1Color = .red
        }
    }
    
    private func updateChatColor4(input : Double) {
        if input < 20 {
            chat2 = "아주 좋아요!"
            chat2Color = .blue
        } else if input < 30 {
            chat2 = "좋아요!"
            chat2Color = .green
        } else if input < 40 {
            chat2 = "나빠요!"
            chat2Color = .yellow
        } else {
            chat2 = "아주 나빠요!"
            chat2Color = .red
        }
    }
    
    private func updateChat1Color() {
        if currentDataNumber < 20 {
            chat1 = "아주 좋아요!"
            chat1Color = .blue
        } else if currentDataNumber < 30 {
            chat1 = "좋아요!"
            chat1Color = .green
        } else if currentDataNumber < 40 {
            chat1 = "나빠요!"
            chat1Color = .yellow
        } else {
            chat1 = "아주 나빠요!"
            chat1Color = .red
        }
    }
    
    private func updateChat2Color() {
        if currentDataNumber2 < 20 {
            chat2 = "아주 좋아요!"
            chat2Color = .blue
        } else if currentDataNumber2 < 30 {
            chat2 = "좋아요!"
            chat2Color = .green
        } else if currentDataNumber2 < 40 {
            chat2 = "나빠요!"
            chat2Color = .yellow
        } else {
            chat2 = "아주 나빠요!"
            chat2Color = .red
        }
    }
    private func updateGradient(with values: [Double]) {
        guard values.count == 10 else {
            return
        }
        
        let colors: [Color] = values.map { value in
            switch value {
            case ..<20:
                return .blue
            case 20..<30:
                return .green
            case 30..<40:
                return .yellow
            default:
                return .red
            }
        }
        
        self.colorline = Gradient(stops: zip(colors, values).map { color, location in
            Gradient.Stop(color: color, location: location)
        })
    }
    
    func simplify(values: [Double]) -> [Double] {
        guard values.count == 48 else {
            return []
        }
        
        let chunkSize = 48 / 10
        var simplifiedValues: [Double] = []
        
        for i in 0..<10 {
            let chunk = values[i*chunkSize..<min((i+1)*chunkSize, values.count)]
            let average = chunk.reduce(0, +) / Double(chunk.count)
            simplifiedValues.append(average)
        }
        
        return simplifiedValues
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
            DispatchQueue.main.async { [self] in
                let forecastDays = data.forecast.forecastday.prefix(4)
                if flag == false {
                    if let forecast = data.forecast.forecastday.first {
                        var x = 0
                        for hour in forecast.hour {
                            x += 1
                            //if x % 2 == 0{
                            if let micro = hour.airQuality?.micro {
                                date1.append(micro)
                                updateChatColor(input: date1.first ?? 25)
                            } else {
                                date1.append(1.1)
                            }
                            
                            if let fine = hour.airQuality?.fine {
                                
                                date2.append(fine)
                            } else {
                                date2.append(1.4)
                            }
                            // }
                            
                        }
                        
                    } else {
                        print("No forecast data available")
                    }
                    
                    if let forecast2 = data.forecast.forecastday[safe: 2] {
                        var x = 0
                        for hour in forecast2.hour {
                            x += 1
                            //print(x)
                            
                            if let micro = hour.airQuality?.micro  {
                                //print(date1)
                                date1.append(micro)
                                updateChatColor4(input: date1.first ?? 10)
                            } else {
                                date1.append(12.0)
                            }
                            
                            if let fine = hour.airQuality?.fine {
                                //print(date2)
                                date2.append(fine)
                            } else {
                                date2.append(12.0)
                            }
                            
                        }
                    } else {
                        print("No forecast data available")
                    }
                    flag = true
                    print(date1)
                    print(simplify(values: date1).count)
                    //updateGradient(with: simplify(values: date1))
                }
                
                
                
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
                    //print(forecastDays[1].day)
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

