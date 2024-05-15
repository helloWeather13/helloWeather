import Foundation
import Alamofire

struct ApiModel {
    let url: String
    let header : HTTPHeaders?
    var parameter : Parameters?
}

extension ApiModel{
    
    // MARK: - kakaoAddress 주소 검색 API 호출용
    static var kakaoAddress = ApiModel(
        url: "https://dapi.kakao.com/v2/local/search/address.json",
        header: ["Authorization" : "KakaoAK 9f7d574ec38f35d53233f50e7bd2a13e"],
        parameter : [ "query" : "", "analyze_type" :"exact"]
    )
    
    // MARK: - forcastWeather 미래 5일 날씨 검색 API 호출용
    static var forcastWeather = ApiModel(
        url: "https://api.weatherapi.com/v1/forecast.json",
        header: ["key" : "c9b70526c91341798a493546241305"],
        parameter: [
            "q" : "",
            "days" : "7",
            "aqi" : "yes",
            "lang" : "ko"
        ])
    // MARK: - historyWeather 과거 날씨 검색 API 호출용 (전날 검색 용)
    static var historyWeather = ApiModel(
        url: "https://api.weatherapi.com/v1/history.json",
        header: ["key" : "c9b70526c91341798a493546241305"],
        parameter: [
            "q" : "",
            "dt" : "",
            "lang" : "ko"
        ])
    
}
