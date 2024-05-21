import WidgetKit
import SwiftUI
import CoreLocation

struct Provider: TimelineProvider {
    
    func fetchWeather(searchModel: SearchModel, completion: @escaping (WidgetModel?,WidgetModel?) -> Void) {
        let apiKey = "c9b70526c91341798a493546241305"
        let urlStringForcast = "https://api.weatherapi.com/v1/forecast.json?q=\(searchModel.lat),\(searchModel.lon)&days=7&aqi=yes&lang=ko&key=\(apiKey)"
        
        guard let yesterday = Calendar.getYesterday() else {return}
        
        let urlStringHistory = "https://api.weatherapi.com/v1/history.json?q=\(searchModel.lat),\(searchModel.lon)&dt=\(yesterday)&lang=ko&key=\(apiKey)"
        
        guard let urlForcast = URL(string: urlStringForcast), let urlHistory = URL(string:urlStringHistory) else {
            completion(nil,nil)
            return
        }
        
        var todayData : WidgetModel?
        var yesterDayData : WidgetModel?
        
        URLSession.shared.dataTask(with: urlForcast) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil,nil)
                return
            }
            let weatherData = try? JSONDecoder().decode(WidgetModel.self, from: data)
            todayData = weatherData
        }.resume()
        
        URLSession.shared.dataTask(with: urlHistory) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil,nil)
                return
            }
            let weatherDataYesterday = try? JSONDecoder().decode(WidgetModel.self, from: data)
            yesterDayData = weatherDataYesterday
            
            let currentTime = DateFormatter()
            currentTime.dateFormat = "HH"
            let currentHour = Int(currentTime.string(from: Date()))!
            print(todayData?.current?.airQuality.micro)
            completion(todayData,yesterDayData)
        }.resume()
    }
    
    func placeholder(in context: Context) -> SimpleEntry {
        let defaultSearchModel = SearchModel(keyWord: "", fullAddress: "Loading...", lat: 0, lon: 0, city: "Loading...")
        return SimpleEntry(date: Date(), location: defaultSearchModel, forecast: nil, yesterday: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.yourcompany.WeatherApp")
        if let data = userDefaults?.data(forKey: "currentSearchModel"),
           let currentSearchModel = try? PropertyListDecoder().decode(SearchModel.self, from: data) {
            fetchWeather(searchModel: currentSearchModel) { weatherDataForcast, weatherDataHistory in
                let entry = SimpleEntry(date: Date(), location: currentSearchModel, forecast: weatherDataForcast, yesterday: weatherDataHistory)
                completion(entry)
            }
        } else {
            let defaultSearchModel = SearchModel(keyWord: "", fullAddress: "No location", lat: 0, lon: 0, city: "No location")
            let entry = SimpleEntry(date: Date(), location: defaultSearchModel, forecast: nil, yesterday: nil)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let userDefaults = UserDefaults(suiteName: "group.com.seungwon.helloWeather")
        if let data = userDefaults?.data(forKey: "currentSearchModel"),
           let currentSearchModel = try? PropertyListDecoder().decode(SearchModel.self, from: data) {
            fetchWeather(searchModel: currentSearchModel) { weatherDataForecast, weatherDataHistory in
                var entries: [SimpleEntry] = []
                
                // Create entries for the next 24 hours, updating every hour
                for hourOffset in 0 ... 24 {
                    let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: Date())!
                    let entry = SimpleEntry(date: entryDate, location: currentSearchModel, forecast: weatherDataForecast,yesterday: weatherDataHistory)
                    entries.append(entry)
                }
                
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
        } else {
            let defaultSearchModel = SearchModel(keyWord: "", fullAddress: "No location", lat: 0, lon: 0, city: "No location")
            let entry = SimpleEntry(date: Date(), location: defaultSearchModel, forecast: nil, yesterday: nil)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let location: SearchModel
    let forecast: WidgetModel?
    let yesterday : WidgetModel?
}

struct HelloWeatherWidgetEntryView : View {
    var entry: Provider.Entry
    var dust : String {
        var dustString = "미세 "
        let fine = Int(entry.forecast?.current?.airQuality.fine ?? -1)
        switch fine{
        case ...30:
            dustString += "좋음"
        case 31...80:
            dustString += "보통"
        case 81...150:
            dustString += "나쁨"
        case 151...:
            dustString += "매우나쁨"
        default:
            dustString += "오류"
        }
        return dustString
    }
    var condition : (text: String , icon : String){
        var condition = ("", "")
        let currentConditon = entry.forecast?.current?.condition.text
        let currentTime = DateFormatter()
        currentTime.dateFormat = "HH"
        let currentHour = Int(currentTime.string(from: Date()))!
        switch currentConditon{
        case "흐린":
            condition = ("흐림","cloudStrong-day")
        case "맑음", "화창함":
            condition = ("맑음",currentHour > 18 ? "clean-night" : "clean-day")
        case "대체로맑음":
            condition = ("대체로 맑음",currentHour > 18 ? "cloud-night" : "cloud-day")
        case "가벼운 소나기":
            condition = ("짧은 소나기",currentHour > 18 ? "rainWeak-night" : "rainWeak-day")
        case "곳곳에 가벼운 이슬비":
            condition = ("가벼운 비",currentHour > 18 ? "rainWeak-night" : "rainWeak-day")
        case "근처 곳곳에 비":
            condition = ("비",currentHour > 18 ? "rainSrong-night" : "rainSrong-day")
        case "보통 또는 심한 소나기":
            condition = ("소나기",currentHour > 18 ? "rainSrong-night" : "rainSrong-day")
        case "폭우":
            condition = ("폭우",currentHour > 18 ? "downpour-night" : "_downpour-day")
        case "근처에 천둥 발생":
            condition = ("낙뢰",currentHour > 18 ? "thunder-night" : "thunder-day")
        case "천둥을 동반한 보통 또는 심한 비":
            condition = ("뇌우",currentHour > 18 ? "storm-night" : "storm-day")
        default:
            condition = (currentConditon ?? "오류" ,currentHour > 18 ? "snow-night" : "snow-day")
        
        }
        return condition
    }
    
    var compare: String{
        var compareString = ""
        let currentTime = DateFormatter()
        currentTime.dateFormat = "HH"
        let currentHour = Int(currentTime.string(from: Date()))!
        
        let yesterDayTemp = Int(entry.yesterday?.forecast.forecastday[0].hour[currentHour].feelslikeC ?? 0)
        let todayTemp = Int(entry.forecast?.current?.feelslikeC ?? 0)
        let difference = yesterDayTemp - todayTemp
        
        switch difference{
        case 0:
            compareString = "어제와 비슷해요"
        case 0...:
            compareString = "어제보다 \(abs(difference))° 낮음"
        default:
            compareString = "어제보다 \(abs(difference))° 높음"
        }
        
        return compareString
    }
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        return formatter
    }
    
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family{
            
        case .systemSmall:
            VStack(alignment: .leading, spacing: 0){
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading , spacing: 15){
                        HStack(alignment: .top, spacing: 0){
                            Image("navigation")
                            Text("\(entry.location.fullAddress), ")
                                .font(Font.custom("Pretendard-Medium", size: 13))
                            Text("\(condition.text)")
                                .font(Font.custom("Pretendard-Light", size: 13))
                        }
                        HStack{
                            Text("\(Int(entry.forecast?.current?.feelslikeC ?? 0))°")
                                .font(Font.custom("GmarketSansTTFBold", size: 47))
                        }
                        .frame(width: 82)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .frame(width: 82)
                    Spacer(minLength: 8)
                    VStack{
                        Image("\(condition.icon)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36,height: 36)
                        Spacer()
                    }
                }
                VStack(alignment: .leading, spacing: 4){
                    Text("\(compare)")
                        .font(Font.custom("Pretendard-Regular", size: 11))
                    Text("\(dust)")
                        .font(Font.custom("Pretendard-Regular", size: 11))
                }
            }
            .widgetBackground(Color(uiColor: UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
            
        case .systemMedium:
            VStack {
                Text("medium:")
                Text(entry.date, style: .time)
                
                Text("TEMP")
                Text(String(entry.forecast?.current?.feelslikeC ?? 0))
                
                Text("Location")
                Text(entry.location.fullAddress)
            }
        case .systemLarge:
            VStack {
                Text("Large:")
                Text(dateFormatter.string(from: entry.date))
                
                Text("TEMP")
                Text(String(entry.forecast?.current?.feelslikeC ?? 0))
                
                Text("Location")
                Text(entry.location.fullAddress)
            }
        default:
            VStack {
                Text("default:")
                Text(entry.date, style: .time)
                
                Text("TEMP")
                Text(String(entry.forecast?.current?.feelslikeC ?? 0))
                
                Text("Location")
                Text(entry.location.fullAddress)
            }
        }
        
    }
}

struct HelloWeatherWidget: Widget {
    let kind: String = "HelloWeatherWidget"
    
    var body: some WidgetConfiguration {
        
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                HelloWeatherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
                    
            } else {
                HelloWeatherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Weather Widget")
        .description("Displays the current weather for your location.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
//        .contentMarginsDisabled()
    }
}

//struct HelloWeatherWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            HelloWeatherWidgetEntryView(entry: SimpleEntry(
//                date: Date(),
//                location: SearchModel(keyWord: "", fullAddress: "고산동", lat: 37.5665, lon: 126.9780, city: "Seoul"),
//                forecast: WidgetModel(
//                    current: WidgetCurrent(condition: WidgetCondition(text: "맑음"), feelslikeC: 25, airQuality: WidgetAirQuality(micro: 10, fine: 10)),
//                    forecast: WidgetForecast(
//                        forecastday: [
//                            WidgetForecastday(date: "2024-05-21", day:
//                                                WidgetDay(maxtempC: 30, mintempC: 15, condition: WidgetCondition(text: "맑음"), airQuality: WidgetAirQuality(micro: 10, fine: 10), avgTemp: 23)
//                                              , airQuality: WidgetAirQuality(micro: 10, fine: 10), hour: [WidgetHour(time: "2024-05-21 17:00", condition: WidgetCondition(text: "맑음"), feelslikeC: 25, airQuality: WidgetAirQuality(micro: 10, fine: 10))])])),
//                yesterday: WidgetModel(
//                    current: WidgetCurrent(condition: WidgetCondition(text: "맑음"), feelslikeC: 25, airQuality: WidgetAirQuality(micro: 10, fine: 10)),
//                    forecast: WidgetForecast(
//                        forecastday: [
//                            WidgetForecastday(date: "2024-05-21", day:
//                                                WidgetDay(maxtempC: 30, mintempC: 15, condition: WidgetCondition(text: "맑음"), airQuality: WidgetAirQuality(micro: 10, fine: 10), avgTemp: 25)
//                                              , airQuality: WidgetAirQuality(micro: 10, fine: 10), hour: [WidgetHour(time: "2024-05-21 17:00", condition: WidgetCondition(text: "맑음"), feelslikeC: 25, airQuality: WidgetAirQuality(micro: 10, fine: 10))])]))
//            ))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//        }
//    }
//}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

extension Calendar {
    static func getYesterday() -> String?{
        let today = Date()
        if let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let yesterdayString = dateFormatter.string(from: yesterday)
            return yesterdayString
        } else {
            return nil
        }
    }
}
