import WidgetKit
import SwiftUI
import CoreLocation

struct Provider: TimelineProvider {
    
    func fetchWeather(searchModel: SearchModel, completion: @escaping (WidgetModel?, WidgetModel?) -> Void) {
        let apiKey = "c9b70526c91341798a493546241305"
        let urlStringForcast = "https://api.weatherapi.com/v1/forecast.json?q=\(searchModel.lat),\(searchModel.lon)&days=2&aqi=yes&lang=ko&key=\(apiKey)"
        
        guard let yesterday = Calendar.getYesterday() else { return }
        
        let urlStringHistory = "https://api.weatherapi.com/v1/history.json?q=\(searchModel.lat),\(searchModel.lon)&dt=\(yesterday)&lang=ko&key=\(apiKey)"
        
        guard let urlForcast = URL(string: urlStringForcast), let urlHistory = URL(string: urlStringHistory) else {
            completion(nil, nil)
            return
        }
        
        var todayData: WidgetModel?
        var yesterDayData: WidgetModel?
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: urlForcast) { data, response, error in
            defer { dispatchGroup.leave() }
            guard let data = data, error == nil else {
                return
            }
            todayData = try? JSONDecoder().decode(WidgetModel.self, from: data)
        }.resume()
        
        dispatchGroup.enter()
        URLSession.shared.dataTask(with: urlHistory) { data, response, error in
            defer { dispatchGroup.leave() }
            guard let data = data, error == nil else {
                return
            }
            yesterDayData = try? JSONDecoder().decode(WidgetModel.self, from: data)
        }.resume()
        
        dispatchGroup.notify(queue: .main) {
            completion(todayData, yesterDayData)
        }
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
            let defaultSearchModel = SearchModel(keyWord: "", fullAddress: "서울시", lat: 0, lon: 0, city: "서울시")
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
                for hourOffset in 0 ..< 1 {
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
    var dust : (String,String) {
        var dustString1 = "미세 "
        var dustString2 = "초미세 "
        let fine = Int(entry.forecast?.current?.airQuality.fine ?? -1)
        let micro = Int(entry.forecast?.current?.airQuality.micro ?? -1)
        switch fine{
        case ...30:
            dustString1 += "좋음"
        case 31...80:
            dustString1 += "보통"
        case 81...150:
            dustString1 += "나쁨"
        case 151...:
            dustString1 += "매우나쁨"
        default:
            dustString1 += "오류"
        }
        switch micro{
        case ...30:
            dustString2 += "좋음"
        case 31...80:
            dustString2 += "보통"
        case 81...150:
            dustString2 += "나쁨"
        case 151...:
            dustString2 += "매우나쁨"
        default:
            dustString2 += "오류"
        }
        return (dustString1, dustString2)
    }
    var condition : (text: String , icon : String){
        var condition = ("", "")
        let currentConditon = entry.forecast?.current?.condition.text
        let currentTime = DateFormatter()
        currentTime.dateFormat = "HH"
        let currentHour = Int(currentTime.string(from: Date()))!
//        print(currentConditon)
        switch currentConditon{
        case "흐린", "구름 낀":
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
            condition = ("폭우","drops_L")
        case "근처에 천둥 발생":
            condition = ("낙뢰",currentHour > 18 ? "thunder-night" : "thunder-day")
        case "천둥을 동반한 보통 또는 심한 비":
            condition = ("뇌우",currentHour > 18 ? "storm-night" : "storm-day")
        case "안개":
            condition = ("안개", "fog_L")
        default:
            condition = (currentConditon ?? "맑음" ,currentHour > 18 ? "clean-night" : "clean-day")
            
            
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
            compareString = "어제와 같음"
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
    var timeWeather : [CurrentWeather]{
        if entry.forecast?.forecast.forecastday[0].hour[0].feelslikeC == nil{
            return [CurrentWeather(temp: "18°", image: "cloudStrong", time: "지금"),
                    CurrentWeather(temp: "19°", image: "clean", time: "17시"),
                    CurrentWeather(temp: "18°", image: "clean", time: "18시"),
                    CurrentWeather(temp: "18°", image: "clean", time: "19시"),
                    CurrentWeather(temp: "20°", image: "clean", time: "20시"),
                    CurrentWeather(temp: "19°", image: "cloudStrong", time: "21시"),]
        }
        var currentWeather : [CurrentWeather] = []
        
        let currentTime = DateFormatter()
        currentTime.dateFormat = "HH"
        let currentHour = Int(currentTime.string(from: Date()))!
        var day = 0
        var hour = currentHour
        
        while currentWeather.count < 6 {
            var temp = ""
            var image = ""
            var time = ""
            
            if hour < 24 {
                if let feelsLike = entry.forecast?.forecast.forecastday[day].hour[hour].feelslikeC,
                   let text = entry.forecast?.forecast.forecastday[day].hour[hour].condition.text{
                    temp = String(Int(feelsLike)) + "°"
                    switch text{
                    case "흐린" , "구름 낀":
                        image = "cloudStrong"
                    case "맑음", "화창함":
                        image = "clean"
                    case "대체로맑음":
                        image = "clean"
                    case "가벼운 소나기":
                        image = "rainWeak"
                    case "곳곳에 가벼운 이슬비":
                        image = "rainWeak"
                    case "근처 곳곳에 비":
                        image = "rainSrong"
                    case "보통 또는 심한 소나기":
                        image = "rainSrong"
                    case "폭우":
                        image = "drops"
                    case "근처에 천둥 발생":
                        image = "thunder"
                    case "천둥을 동반한 보통 또는 심한 비":
                        image = "storm"
                    case "안개":
                        image = "fog"
                    default:
                        image = "snow"
                    }
                    if hour == currentHour {
                        time = "지금"
                    }else{
                        time = "\(hour)시"
                    }
                    currentWeather.append(CurrentWeather(temp: temp, image: image, time: time))
                    hour += 1
                }
                else{
                    currentWeather.append(CurrentWeather(temp: "temp", image: "clean", time: "time"))
                    hour += 1
                }
            }else{
                day = 1
                hour = 0
            }
        }
        return currentWeather
    }
    func changeDataToHeight(temp : String) -> Double{
        var height: Double = 0.0
        if let tempC = Double(temp.dropLast()) {
            switch tempC {
            case ..<0:
                height = 0.1
            case 0..<10:
                height = 0.2
            case 10..<15:
                height = 0.3
            case 15..<20:
                height = 0.4
            case 20..<25:
                height = 0.5
            case 25..<30:
                height = 0.6
            case 30..<35:
                height = 0.7
            case 35..<40:
                height = 0.8
            default:
                height = 0.9
            }
        }
        return height
    }
    @Environment(\.widgetFamily) var family
    var body: some View {
        switch family{
        case .systemSmall:
            HStack{
                Spacer(minLength: 16)
                VStack(alignment: .leading, spacing: 7){
                    Spacer(minLength: 16)
                    VStack(alignment: .leading , spacing: 4){
                        HStack(alignment: .top, spacing: 2){
                            Image("navigation")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(Color(UIColor.label))
                                .frame(width: 12,height: 17)
                            Text("\(entry.location.fullAddress),")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Bold", size: 13)!, lineHeight: 16)
                                .kerning(0.08)
                            Text("\(condition.text)")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 13)!, lineHeight: 16)
                                .kerning(0.08)
                            Spacer()
                        }
                        
                        Text("\(Int(entry.forecast?.current?.feelslikeC ?? 19))°")
                            .fontWithLineHeight(font: UIFont(name: "Nunito-Black", size: 62)!, lineHeight: 62)
                            .kerning(-0.6)
                    }
                    HStack(){
                        VStack(alignment: .leading, spacing: 4){
                            Text("\(compare)")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                                .kerning(0.07)
                            Text("\(dust.0)")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                                .kerning(0.07)
                        }
                        Spacer()
                        HStack(alignment: .center){
                            Image("\(condition.icon)")
                                .frame(width: 36,height: 36)
                                .aspectRatio(contentMode: .fit)
                            
                        }
                    }
                    Spacer(minLength: 16)
                }
                Spacer(minLength: 16)
            }.widgetBackground(Color(uiColor: UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
            
        case .systemMedium:
            VStack{
                Spacer(minLength: 16)
                HStack{
                    Spacer(minLength: 16)
                    VStack (alignment: .leading, spacing: 13) {
                        VStack(alignment: .leading , spacing: 4){
                            HStack(alignment: .center, spacing: 2){
                                Image("navigation")
                                    .resizable()
                                    .renderingMode(.template)
                                    .aspectRatio(contentMode: .fill)
                                    .foregroundColor(Color(UIColor.label))
                                    .frame(width: 12,height: 17)
                                Text("\(entry.location.fullAddress),")
                                    .fontWithLineHeight(font: UIFont(name: "Pretendard-Bold", size: 16)!, lineHeight: 17)
                                    .kerning(0.08)
                                Text("\(condition.text)")
                                    .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                                    .kerning(0.08)
                                Spacer()
                            }
                            HStack{
                                Text("\(Int(entry.forecast?.current?.feelslikeC ?? 19))°")
                                    .fontWithLineHeight(font: UIFont(name: "Nunito-Black", size: 62)!, lineHeight: 62)
                                    .kerning(0.05)
                                Spacer()
                            }
                            
                        }
                        VStack(alignment: .leading, spacing: 4){
                            Text("\(compare)")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                                .kerning(0.07)
                            Text("\(dust.0)")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                                .kerning(0.07)
                        }
                    }
                    Spacer(minLength: 72)
                    VStack(alignment: .trailing, spacing: 4){
                        HStack(){
                            Image("\(condition.icon)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36,height: 36)
                        }
                        
                        Text("\(Int(entry.forecast?.forecast.forecastday[0].day.maxtempC ?? 26))° / \(Int(entry.forecast?.forecast.forecastday[0].day.mintempC ?? 19))°")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 13)!, lineHeight: 13)
                            .kerning(0.07)
                        Spacer()
                    }
                    Spacer(minLength: 16)
                }
                Spacer(minLength: 16)
            }
            .widgetBackground(Color(uiColor: UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
            
        case .systemLarge:
            HStack{
                VStack{
                    Spacer(minLength: 10)
                    HStack{
                        Spacer(minLength: 16)
                        VStack (alignment: .leading, spacing: 13) {
                            VStack(alignment: .leading , spacing: 4){
                                HStack(alignment: .center, spacing: 2){
                                    Image("navigation")
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fill)
                                        .foregroundColor(Color(UIColor.label))
                                        .frame(width: 12,height: 17)
                                    Text("\(entry.location.fullAddress),")
                                        .fontWithLineHeight(font: UIFont(name: "Pretendard-Bold", size: 16)!, lineHeight: 17)
                                        .kerning(0.08)
                                    Text("\(condition.text)")
                                        .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                                        .kerning(0.08)
                                    Spacer()
                                }
                                HStack{
                                    Text("\(Int(entry.forecast?.current?.feelslikeC ?? 19))°")
                                        .fontWithLineHeight(font: UIFont(name: "Nunito-Black", size: 62)!, lineHeight: 62)
                                        .kerning(0.05)
                                    Spacer()
                                }
                                
                            }
                            VStack(alignment: .leading, spacing: 4){
                                Text("\(compare)")
                                    .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                                    .kerning(0.07)
                                Text("\(dust.0) · \(dust.1)")
                                    .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                                    .kerning(0.07)
                            }
                        }
                        Spacer(minLength: 72)
                        VStack(alignment: .trailing, spacing: 4){
                            HStack(){
                                Image("\(condition.icon)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36,height: 36)
                            }
                            
                            Text("\(Int(entry.forecast?.forecast.forecastday[0].day.maxtempC ?? 26))° / \(Int(entry.forecast?.forecast.forecastday[0].day.mintempC ?? 19))°")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 13)!, lineHeight: 13)
                                .kerning(0.07)
                            Spacer()
                        }
                        Spacer(minLength: 16)
                    }
                    Spacer(minLength: 16)
                   
                }
                
            }.widgetBackground(Color(uiColor: UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
            
            VStack{
                Divider()
                HStack(){
                    Spacer(minLength: 16)
                    VStack(alignment: .center){
                        Spacer(minLength: 22)
                        Text("\(timeWeather[0].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 20)!, lineHeight: 20)
                            .kerning(0.24)
                        Spacer(minLength: 3)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[0].temp), width: 50, numberOfDataPoints: 10, accentColor: .gray, touchLocation: .constant(-1.0))
                        Spacer(minLength: 4)
                        Image(timeWeather[0].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 22)
                        Text("\(timeWeather[0].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                        Spacer(minLength: 27)
                    }
                    Spacer(minLength: 16)
                    VStack(alignment: .center){
                        Spacer(minLength: 22)
                        Text("\(timeWeather[1].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 15)!, lineHeight: 20)
                            .kerning(0.24)
                        Spacer(minLength: 3)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[1].temp), width: 50, numberOfDataPoints: 10, accentColor: .gray, touchLocation: .constant(-1.0))
                        Spacer(minLength: 4)
                        Image(timeWeather[1].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 22)
                        Text("\(timeWeather[1].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                        Spacer(minLength: 27)
                    }
                    Spacer(minLength: 16)
                    VStack(alignment: .center){
                        Spacer(minLength: 22)
                        Text("\(timeWeather[2].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 15)!, lineHeight: 20)
                            .kerning(0.24)
                        Spacer(minLength: 3)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[2].temp), width: 50, numberOfDataPoints: 10, accentColor: .gray, touchLocation: .constant(-1.0))
                        Spacer(minLength: 4)
                        Image(timeWeather[2].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 22)
                        Text("\(timeWeather[2].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                        Spacer(minLength: 27)
                    }
                    Spacer(minLength: 16)
                    VStack(alignment: .center){
                        Spacer(minLength: 22)
                        Text("\(timeWeather[3].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 15)!, lineHeight: 20)
                            .kerning(0.24)
                        Spacer(minLength: 3)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[3].temp), width: 50, numberOfDataPoints: 10, accentColor: .gray, touchLocation: .constant(-1.0))
                        Spacer(minLength: 4)
                        Image(timeWeather[3].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 22)
                        Text("\(timeWeather[3].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                        Spacer(minLength: 27)
                    }
                    Spacer(minLength: 16)
                    VStack(alignment: .center){
                        Spacer(minLength: 22)
                        Text("\(timeWeather[4].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 15)!, lineHeight: 20)
                            .kerning(0.24)
                        Spacer(minLength: 3)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[4].temp), width: 50, numberOfDataPoints: 10, accentColor: .gray, touchLocation: .constant(-1.0))
                        Spacer(minLength: 4)
                        Image(timeWeather[4].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 22)
                        Text("\(timeWeather[4].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                        Spacer(minLength: 27)
                    }
                    Spacer(minLength: 16)
                    VStack(alignment: .center){
                        Spacer(minLength: 22)
                        Text("\(timeWeather[5].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 15)!, lineHeight: 20)
                            .kerning(0.24)
                        Spacer(minLength: 3)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[5].temp), width: 50, numberOfDataPoints: 10, accentColor: .gray, touchLocation: .constant(-1.0))
                        Spacer(minLength: 4)
                        Image(timeWeather[5].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 22)
                        Text("\(timeWeather[5].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                        Spacer(minLength: 27)
                    }
                    Spacer(minLength: 16)
                }
            }
            .frame(height: 195)
            .widgetBackground(Color(uiColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1.00)))
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
        .contentMarginsDisabled()
    }
}

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

struct FontWithLineHeight: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}

extension View {
    func fontWithLineHeight(font: UIFont, lineHeight: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: FontWithLineHeight(font: font, lineHeight: lineHeight))
    }
}
