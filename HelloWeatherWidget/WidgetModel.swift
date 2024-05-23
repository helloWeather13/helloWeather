import Foundation

// MARK: - Welcome
struct WidgetModel: Codable {
    let current: WidgetCurrent? // 현재 기상 정보
    let forecast: WidgetForecast // 미래 (7일 24시간 정보)
}

// MARK: - Current
struct WidgetCurrent: Codable { // 현재 시간 기준
    let condition: WidgetCondition // Condition -> 맑음, 등등 정보
    let feelslikeC: Double // 현재 체감온도 온도 C 섭씨, F 화씨
    let airQuality: WidgetAirQuality // 현재 공기 오염도, 미세먼지 + 초미세먼지만 나옴
    
    enum CodingKeys: String, CodingKey {
        case airQuality = "air_quality"
        case condition
        case feelslikeC = "feelslike_c"
    }
}

// MARK: - Condition
struct WidgetCondition: Codable {
    let text: String // 날씨 컨디션 : 맑음, 등등
}

// MARK: - Forecast
struct WidgetForecast: Codable { // 미리 7일간의 데이터 저장용
    let forecastday: [WidgetForecastday]
}

// MARK: - Forecastday
struct WidgetForecastday: Codable { // 하루 기준으로 나오는 정보
    let date: String // 날짜 String
    let day: WidgetDay // 하루 날씨 정보
    let airQuality: WidgetAirQuality? // 미세먼지 정보
    let hour: [WidgetHour] // 하루를 24시간으로 쪼개서 각각의 날씨 정보
    enum CodingKeys: String, CodingKey {
        case date, day, hour
        case airQuality = "air_quality"
        
    }
}

struct WidgetAirQuality : Codable { //
    let micro : Double? // 초미세먼지 정도
    let fine : Double? // 미세먼지 정도
    
    enum CodingKeys: String, CodingKey {
        case micro = "pm10"
        case fine = "pm2_5"
    }
}
// MARK: - Day
struct WidgetDay: Codable {
    let maxtempC, mintempC: Double // 최고 최저 온도 C 섭씨, F 화씨
    let condition: WidgetCondition // 날씨 컨디션 : 맑음, 등등
    let airQuality: WidgetAirQuality? // 공기 오염도, 미세먼지 + 초미세먼지만 나옴
    let avgTemp: Double
    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case condition
        case airQuality = "air_quality"
        case avgTemp = "avgtemp_c"
    }
}

// MARK: - Hour
struct WidgetHour: Codable {
    let time: String // 관측 시간 String
    let condition: WidgetCondition // 날씨 컨디션 : 맑음, 등등
    let feelslikeC: Double // 체감온도 온도 C 섭씨, F 화씨
    let airQuality: WidgetAirQuality?
    enum CodingKeys: String, CodingKey {
        case time
        case condition
        case feelslikeC = "feelslike_c"
        case airQuality = "air_quality"
    }
}


struct CurrentWeather {
    let temp : String
    let image : String
    let time : String
}

