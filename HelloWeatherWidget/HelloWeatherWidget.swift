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
//        print(currentConditon)
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
            condition = (currentConditon ?? "맑음" ,currentHour > 18 ? "snow-night" : "snow-day")
            
            
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
            
            if let feelsLike = entry.forecast?.forecast.forecastday[day].hour[hour].feelslikeC {
                temp = String(Int(feelsLike)) + "°"
                switch entry.forecast?.forecast.forecastday[day].hour[hour].condition.text{
                case "흐린":
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
                    image = "downpour"
                case "근처에 천둥 발생":
                    image = "thunder"
                case "천둥을 동반한 보통 또는 심한 비":
                    image = "storm"
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
            VStack(alignment: .leading, spacing: 7){
                VStack(alignment: .leading , spacing: 4){
                    HStack(alignment: .top, spacing: 2){
                        Image("navigation")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 12,height: 17)
                        Text("\(entry.location.fullAddress),")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Bold", size: 13)!, lineHeight: 16)
                            .kerning(0.08)
                        Text("\(condition.text)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 13)!, lineHeight: 16)
                            .kerning(0.08)
                        Spacer()
                    }
                    
                    Text("\(Int(entry.forecast?.current?.feelslikeC ?? 0))°")
                        .fontWithLineHeight(font: UIFont(name: "Nunito-Black", size: 62)!, lineHeight: 62)
                        .kerning(-0.6)
                }
                HStack(){
                    VStack(alignment: .leading, spacing: 4){
                        Text("\(compare)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                            .kerning(0.07)
                        Text("\(dust)")
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
                
            }
            .widgetBackground(Color(uiColor: UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
            
        case .systemMedium:
            HStack{
                VStack (alignment: .leading, spacing: 13) {
                    VStack(alignment: .leading , spacing: 4){
                        HStack(alignment: .center, spacing: 2){
                            Image("navigation")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 12,height: 17)
                            Text("\(entry.location.fullAddress),")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Bold", size: 16)!, lineHeight: 17)
                                .kerning(0.08)
                            Text("\(condition.text)")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                                .kerning(0.08)
                        }
                        HStack{
                            Text("\(Int(entry.forecast?.current?.feelslikeC ?? 0))°")
                                .fontWithLineHeight(font: UIFont(name: "Nunito-Black", size: 62)!, lineHeight: 62)
                                .kerning(0.05)
                        }
                        
                    }
                    VStack(alignment: .leading, spacing: 4){
                        Text("\(compare)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                            .kerning(0.07)
                        Text("\(dust)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                            .kerning(0.07)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4){
                    HStack(){
                        Image("\(condition.icon)")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36,height: 36)
                    }
                    
                    Text("\(Int(entry.forecast?.forecast.forecastday[0].day.maxtempC ?? 0))° / \(Int(entry.forecast?.forecast.forecastday[0].day.mintempC ?? 0))°")
                        .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 13)!, lineHeight: 13)
                        .kerning(0.07)
                    Spacer()
                }
            }.widgetBackground(Color(uiColor: UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1.00)))
            
        case .systemLarge:
            VStack{
                HStack{
                    VStack (alignment: .leading, spacing: 13) {
                        VStack(alignment: .leading , spacing: 4){
                            HStack(alignment: .top, spacing: 2){
                                Image("navigation")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 12,height: 17)
                                Text("\(entry.location.fullAddress),")
                                    .fontWithLineHeight(font: UIFont(name: "Pretendard-Bold", size: 16)!, lineHeight: 17)
                                    .kerning(0.08)
                                Text("\(condition.text)")
                                    .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                                    .kerning(0.08)
                            }
                            HStack{
                                Text("\(Int(entry.forecast?.current?.feelslikeC ?? 0))°")
                                    .fontWithLineHeight(font: UIFont(name: "Nunito-Black", size: 62)!, lineHeight: 62)
                                    .kerning(0.05)
                            }
                            
                        }
                        VStack(alignment: .leading, spacing: 4){
                            Text("\(compare)")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                                .kerning(0.07)
                            Text("\(dust)")
                                .fontWithLineHeight(font: UIFont(name: "Pretendard-Medium", size: 11)!, lineHeight: 13)
                                .kerning(0.07)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4){
                        HStack(){
                            Image("\(condition.icon)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 36,height: 36)
                        }
                        
                        Text("\(Int(entry.forecast?.forecast.forecastday[0].day.maxtempC ?? 0))° / \(Int(entry.forecast?.forecast.forecastday[0].day.mintempC ?? 0))°")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 13)!, lineHeight: 13)
                            .kerning(0.07)
                        Spacer()
                    }
                    
                }
                Spacer()
                Divider()
                Spacer()
                HStack(){
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(timeWeather[0].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 20)!, lineHeight: 20)
                            .kerning(0.24)
                        Spacer(minLength: 6)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[0].temp), width: 50, numberOfDataPoints: 10, accentColor: .gray, touchLocation: .constant(-1.0))
                        Spacer(minLength: 9)
                        Image(timeWeather[0].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 16)
                        Text("\(timeWeather[0].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(timeWeather[1].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                            .kerning(0.24)
                        Spacer(minLength: 6)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[1].temp), width: 50, numberOfDataPoints: 10, accentColor: Color(uiColor: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)), touchLocation: .constant(-1.0))
                        Spacer(minLength: 9)
                        Image(timeWeather[1].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 16)
                        Text("\(timeWeather[1].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(timeWeather[2].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                            .kerning(0.24)
                        Spacer(minLength: 6)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[2].temp), width: 50, numberOfDataPoints: 10, accentColor: Color(uiColor: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)), touchLocation: .constant(-1.0))
                        Spacer(minLength: 9)
                        Image(timeWeather[2].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 16)
                        Text("\(timeWeather[2].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(timeWeather[3].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                            .kerning(0.24)
                        Spacer(minLength: 6)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[3].temp), width: 50, numberOfDataPoints: 10, accentColor: Color(uiColor: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)), touchLocation: .constant(-1.0))
                        Spacer(minLength: 9)
                        Image(timeWeather[3].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 16)
                        Text("\(timeWeather[3].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(timeWeather[4].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                            .kerning(0.24)
                        Spacer(minLength: 6)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[4].temp), width: 50, numberOfDataPoints: 10, accentColor: Color(uiColor: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)), touchLocation: .constant(-1.0))
                        Spacer(minLength: 9)
                        Image(timeWeather[4].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 16)
                        Text("\(timeWeather[4].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                    }
                    Spacer()
                    VStack(alignment: .center){
                        Text("\(timeWeather[5].temp)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 16)!, lineHeight: 17)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                            .kerning(0.24)
                        Spacer(minLength: 6)
                        BarChartCell5(value: changeDataToHeight(temp: timeWeather[5].temp), width: 50, numberOfDataPoints: 10, accentColor: Color(uiColor: UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)), touchLocation: .constant(-1.0))
                        Spacer(minLength: 9)
                        Image(timeWeather[5].image)
                            .frame(width: 24, height: 24)
                        Spacer(minLength: 16)
                        Text("\(timeWeather[5].time)")
                            .fontWithLineHeight(font: UIFont(name: "Pretendard-Regular", size: 11)!, lineHeight: 14.85)
                            .foregroundColor(Color(uiColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)))
                    }
                    Spacer()
                }
                Spacer()
            }
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
        //        .contentMarginsDisabled()
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
