import Foundation

// MARK: - Welcome
struct WeatherAPIModel: Codable {
    let current: Current // 현재 기상 정보
    let forecast: Forecast // 미래 (7일 24시간 정보)
}

// MARK: - Current
struct Current: Codable {
    let lastUpdated: String
    let tempC, tempF: Double
    let condition: Condition
    let windMph,windKph : Double
    let humidity, cloud: Int
    let feelslikeC, feelslikeF: Double
    let airQuality: AirQuality
    let uv: Double

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case uv
        case airQuality = "air_quality"
    }
}

// MARK: - Condition
struct Condition: Codable {
    let text: String
}

// MARK: - Forecast
struct Forecast: Codable {
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable {
    let date: String
    let dateEpoch: Int
    let day: Day
    let astro: Astro
    let hour: [Hour]
    
    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, astro, hour
        
    }
}

// MARK: - Astro
struct Astro: Codable {
    let sunrise, sunset: String

    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
}

struct AirQuality : Codable {
    let micro : Double
    let fine : Double
    enum CodingKeys: String, CodingKey {
        case micro = "pm10"
        case fine = "pm2_5"
    }
    
}
// MARK: - Day
struct Day: Codable {
    let maxtempC, maxtempF, mintempC, mintempF: Double
    let avgtempC, avgtempF, maxwindMph, maxwindKph: Double
    let totalsnowCM, avghumidity: Int
    let dailyWillItRain, dailyChanceOfRain, dailyWillItSnow, dailyChanceOfSnow: Int
    let condition: Condition
    let uv: Int

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalsnowCM = "totalsnow_cm"
        case avghumidity
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition, uv
    }
}

// MARK: - Hour
struct Hour: Codable {
    let time: String
    let tempC, tempF: Double
    let condition: Condition
    let windMph, windKph: Double
    let snowCM, humidity, cloud: Int
    let feelslikeC, feelslikeF: Double
    let willItRain, chanceOfRain, willItSnow, chanceOfSnow: Int
    let uv: Int

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case snowCM = "snow_cm"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
        case uv
    }
}

