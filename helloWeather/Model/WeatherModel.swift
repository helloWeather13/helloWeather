//// This file was generated from JSON Schema using quicktype, do not modify it directly.
//// To parse the JSON, add this file to your project and do:
////
////   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)
//
//import Foundation
//
//// MARK: - Welcome
//struct OpenWeather : Codable{
//    let list: [List]
//    let city : City
//}
//
//// MARK: - List
//struct List : Codable {
//    let dt: Int
//    let main: MainClass
//    let weather: [Weather]
//    let clouds: Clouds
//    let wind: Wind
//    let pop: Double
//    let dtTxt: String
//    enum CodingKeys : String , CodingKey {
//        case dt,main,weather,clouds,wind,pop
//        case dtTxt = "dt_txt"
//    }
//}
//
//struct City : Codable {
//    let sunrise : Int
//    let sunset : Int
//}
//
//// MARK: - Clouds
//struct Clouds: Codable {
//    let all: Int
//}
//
//// MARK: - MainClass
//struct MainClass: Codable {
//    let temp, feelsLike, tempMin, tempMax: Double
//    let humidity: Int
//    enum CodingKeys : String , CodingKey {
//        case temp,humidity
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//    }
//}
//
//// MARK: - Weather
//struct Weather: Codable {
//    let description, icon: String
//}
//
//// MARK: - Wind
//struct Wind: Codable {
//    let speed: Double
//}
