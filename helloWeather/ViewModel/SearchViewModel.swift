//
//  SearchViewModel.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import Foundation
import Alamofire

class SearchViewModel {
    
    var kakaoAddress = ApiModel(
        url: "https://dapi.kakao.com/v2/local/search/address.json",
        header: ["Authorization" : "KakaoAK 9f7d574ec38f35d53233f50e7bd2a13e"],
        parameter : [ "query" : "경기도 광명시"]
    )
    
    
    var newWeather = ApiModel(
        url: "https://api.weatherapi.com/v1/forecast.json",
        header: ["key" : "c9b70526c91341798a493546241305"],
        parameter: [
            "q" : "37.490749226867,126.867941213494",
            "days" : "7",
            "aqi" : "yes",
            "lang" : "ko"
        ])
    
    func getResult<T: Codable>(apiModel : ApiModel, expecting: T.Type ){
        WebServiceManager.shared.requestAPI(url: apiModel.url, expecting: expecting, headers: apiModel.header, parameters: apiModel.parameter){  result in
            switch result{
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
