//
//  SearchViewModel.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import Foundation
import Alamofire
import UIKit

class SearchViewModel {
    var state : State = .beforeSearch
    var relatedSearch : [RelatedSearchModel] = []
    var dataSource: UITableViewDiffableDataSource<SearchViewSection, SearchViewSectionItem>?
    
    
    var kakaoAddress = ApiModel(
        url: "https://dapi.kakao.com/v2/local/search/address.json",
        header: ["Authorization" : "KakaoAK 9f7d574ec38f35d53233f50e7bd2a13e"],
        parameter : [ "query" : "경기도 광명시", "analyze_type" :"exact"]
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
    
    
    
    func getKakaoAddressResult(address : String){
        relatedSearch = []
        self.kakaoAddress.parameter?["query"] = address
        WebServiceManager.shared.requestAPI(url: self.kakaoAddress.url, expecting: KakaoAddressModel.self, headers: self.kakaoAddress.header, parameters: self.kakaoAddress.parameter){  result in
            switch result{
            case .success(let data):
                self.convertDataToRelatedModel(data: data, address: address)
                self.applySnapshot()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getWeather(lat : String, lon: String){
        let q = lat + "," + lon
        self.newWeather.parameter!["q"] = q
        
        WebServiceManager.shared.requestAPI(url: self.newWeather.url, expecting: WeatherAPIModel.self, headers: self.newWeather.header, parameters: self.newWeather.parameter){  result in
            switch result{
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    func convertDataToRelatedModel(data: KakaoAddressModel, address : String){
        data.documents.forEach{
            var fullName = $0.address.regionNameFirst + " "
            + $0.address.regionNameSecond + " "
            if $0.address.regionNameThirdH != "" {
                fullName += $0.address.regionNameThirdH
            }else{
                fullName += $0.address.regionNameThird
            }
            relatedSearch.append(RelatedSearchModel(keyWord: address, fullAddress: fullName, lat: Double($0.address.lat) ?? 0, lon: Double($0.address.lat) ?? 0))
        }
    }
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SearchViewSection, SearchViewSectionItem>()
        switch state {
        case .beforeSearch:
            snapshot.appendSections([.recentSearch])
        case .searching:
            snapshot.appendSections([.relatedSearch])
            let items:[SearchViewSectionItem] = relatedSearch.map({
                .relatedSearch($0)
            })
            snapshot.appendItems(items)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    
}
