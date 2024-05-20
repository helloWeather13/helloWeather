//
//  SearchViewModel.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import Foundation
import Alamofire
import UIKit
import MapKit

class SearchViewModel {
    
    var searchCompleter: MKLocalSearchCompleter?
    var searchRegion: MKCoordinateRegion = MKCoordinateRegion(MKMapRect.world)
    var completerResults: [MKLocalSearchCompletion]?
    

    
    var state : SearchState = .beforeSearch
    var relatedSearch : [SearchModel] = []
    var recentSearch : [SearchModel] = []
    var dataSource: UITableViewDiffableDataSource<SearchViewSection, SearchViewSectionItem>?
    
    init(){
        loadRecentSearch()
    }
    
    // MARK: - appendRecentSearch 검색하고 클릭한 주소를 최근 검색 결과에 저장
    func appendRecentSearch(data : SearchModel){
        if !self.recentSearch.contains(where:{
            $0.fullAddress == data.fullAddress
        }){
            self.recentSearch.append(data)
            saveRecentSearch()
        }
    }
    
    // MARK: - saveRecentSearch UserDefault에 최근 검색 결과 저장
    func saveRecentSearch() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.recentSearch){
            UserDefaults.standard.setValue(encoded, forKey: "recentSearch")
        }
    }
    
    // MARK: - loadRecentSearch UserDefault에 최근 검색 결과 로드
    func loadRecentSearch(){
        if let savedData = UserDefaults.standard.object(forKey: "recentSearch") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([SearchModel].self, from: savedData) {
                self.recentSearch = savedObject
            }
        }
    }
    
    // MARK: - deleteRecentSearch UserDefault에서 최근 결과 삭제
    func deleteRecentSearch(){
        recentSearch.removeAll()
        UserDefaults.standard.removeObject(forKey: "recentSearch")
        self.applySnapshot()
    }
    
    // MARK: - getWeatherResult WebSeriveManager로 날씨데이터 받아오고, SearchModel 즉 주소 정보 포함된 변수로 호출
    func getWeatherResult(searchModel : SearchModel){
        WebServiceManager.shared.getForecastWeather(searchModel: searchModel, completion: { weatherData in
            print(weatherData)
        })
//        WebServiceManager.shared.getHistoryWeather(searchModel: searchModel, completion: { weatherData in
//            print(weatherData)
//        })
        
    }
    
    // MARK: - getSearchResult WebSeriveManager로 주소 데이터 받아오고, SearchBar Text로 호출
    func getSearchResult(address : String, completion: @escaping (Bool) -> Void){
        WebServiceManager.shared.getKakaoAddressResult(address: address, completion:{ addressModel in
            if addressModel.documents.count == 0 {
                completion(true)
            }else{
                completion(false)
                self.convertDataToRelatedModel(data: addressModel, address: address)
                self.applySnapshot()
            }
            
        })
    }
    
    // MARK: - convertDataToRelatedModel WebSeriveManager로 받아온 주소 데이터를 사용할 수 있게끔 SearchModel로 변환
    func convertDataToRelatedModel(data: KakaoAddressModel, address : String){
        relatedSearch = []
        data.documents.forEach{
            var city = ""
            var fullName = $0.address.regionNameFirst + " "
            
            if $0.address.regionNameSecond == "" {
                city = $0.address.regionNameFirst
            }else{
                fullName += $0.address.regionNameSecond + " "
                
                if $0.address.regionNameThirdH != "" {
                    fullName += $0.address.regionNameThirdH
                    city = $0.address.regionNameThirdH
                }else{
                    if $0.address.regionNameThird == "" {
                        city = $0.address.regionNameSecond
                    }else{
                        fullName += $0.address.regionNameThird
                        city = $0.address.regionNameThird
                    }
                }
            }
            
            relatedSearch.append(SearchModel(keyWord: address, fullAddress: fullName, lat: Double($0.address.lat) ?? 0, lon: Double($0.address.lat) ?? 0, city: city))
        }
    }
    // MARK: - applySnapshot 데이터로 최근검색 / 연관 검색 TableView SnapShot 적용
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SearchViewSection, SearchViewSectionItem>()
        switch state {
        case .beforeSearch:
            snapshot.appendSections([.recentSearch])
            let items:[SearchViewSectionItem] = recentSearch.map({
                .recentSearch($0)
            })
            snapshot.appendItems(items)
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
