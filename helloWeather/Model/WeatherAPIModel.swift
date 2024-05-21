import Foundation

// MARK: - Welcome
struct WeatherAPIModel: Codable {
    let current: Current? // 현재 기상 정보
    let forecast: Forecast // 미래 (7일 24시간 정보)
}

// MARK: - Current
struct Current: Codable { // 현재 시간 기준
    let lastUpdated: String // 업데이트 시간 (String)
    let tempC, tempF: Double // 현재 온도 C 섭씨, F 화씨
    let condition: Condition // Condition -> 맑음, 등등 정보
    let windMph,windKph : Double // 풍속 Mph 마일, Kph 키로
    let humidity : Int // 습도 0 - 100
    let cloud: Int // 구름 0 - 100
    let feelslikeC, feelslikeF: Double // 현재 체감온도 온도 C 섭씨, F 화씨
    let airQuality: AirQuality // 현재 공기 오염도, 미세먼지 + 초미세먼지만 나옴
    let uv: Double // 자외선
    
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
    let text: String // 날씨 컨디션 : 맑음, 등등
    
    func change() -> String {
        switch self.text {
        case "흐린", "구름 낀", "안개":
            return "흐림"
        case "맑음", "화창함":
            return "맑음"
        case "대체로 맑음":
            return "대체로 맑음"
        case "가벼운 소나기":
            return "짧은 소나기"
        case "곳곳에 가벼운 이슬비":
            return "가벼운 비"
        case "근처 곳곳에 비", "비":
            return "비"
        case "보통 또는 심한 소나기":
            return "소나기"
        case "폭우":
            return "폭우"
        case "근처에 천둥 발생":
            return "낙뢰"
        case "천둥을 동반한 보통 또는 심한 비":
            return "뇌우"
        default:
            return ""
        }
    }
}


// MARK: - Forecast
struct Forecast: Codable { // 미리 7일간의 데이터 저장용
    let forecastday: [Forecastday]
}

// MARK: - Forecastday
struct Forecastday: Codable { // 하루 기준으로 나오는 정보
    let date: String // 날짜 String
    let day: Day // 하루 날씨 정보
    let astro: Astro // 일출 정보 용
    let airQuality: AirQuality? // 미세먼지 정보
    let hour: [Hour] // 하루를 24시간으로 쪼개서 각각의 날씨 정보
    enum CodingKeys: String, CodingKey {
        case date, day, astro, airQuality, hour
        
    }
}

// MARK: - Astro
struct Astro: Codable {
    let sunrise, sunset: String // 일몰, 일출 시간 String
    
    enum CodingKeys: String, CodingKey {
        case sunrise, sunset
    }
}

struct AirQuality : Codable { //
    let micro : Double? // 초미세먼지 정도
    let fine : Double? // 미세먼지 정도
    let o3 : Double? // 오존3
    let co : Double? // 일산화 탄소
    let no2 : Double? // 이산화질소
    let so2 : Double? // 이산화황
    
    enum CodingKeys: String, CodingKey {
        case micro = "pm10"
        case fine = "pm2_5"
        case o3 = "o3"
        case co = "co"
        case no2 = "no2"
        case so2 = "so2"
    }
}
// MARK: - Day
struct Day: Codable {
    let maxtempC, maxtempF, mintempC, mintempF: Double // 최고 최저 온도 C 섭씨, F 화씨
    let avgtempC, avgtempF, maxwindMph, maxwindKph: Double // 평균 온도 온도 C 섭씨, F 화씨, 최대 풍속
    let totalsnowCM, avghumidity: Int // 눈 오는 양 CM, 평균 습도
    let dailyWillItRain, dailyChanceOfRain : Int // 강수 확률 chance -> 퍼센트로, willitRain는 0 Or 1
    let dailyWillItSnow, dailyChanceOfSnow: Int //  눈올 확률 chance -> 퍼센트로, willitSnow는 0 Or 1
    let condition: Condition // 날씨 컨디션 : 맑음, 등등
    let airQuality: AirQuality? // 공기 오염도, 미세먼지 + 초미세먼지만 나옴
    let uv: Int // 자외선 수치
    
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
        case airQuality = "air_quality"
    }
}

// MARK: - Hour
struct Hour: Codable {
    let time: String // 관측 시간 String
    let tempC, tempF: Double // 온도 C 섭씨, F 화씨
    let condition: Condition // 날씨 컨디션 : 맑음, 등등
    let windMph, windKph: Double // 풍속 Mph 마일, Kph 키로
    let snowCM : Int // 눈 CM
    let humidity, cloud: Int // 습도 구름 0-100
    let feelslikeC, feelslikeF: Double // 체감온도 온도 C 섭씨, F 화씨
    let willItRain, chanceOfRain, willItSnow, chanceOfSnow: Int
    let airQuality: AirQuality?
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
        case airQuality = "air_quality"
        case uv
    }
}
