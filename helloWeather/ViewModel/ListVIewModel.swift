//
//  ListViewModel.swift
//  helloWeather
//
//  Created by Seungseop Lee on 5/13/24.
//

import Foundation
import UIKit
import Combine
import Alamofire

class ListViewModel {
    let group = DispatchGroup()
    var searchModel : [SearchModel] = []
    var weatherAPIModel : [WeatherAPIModel] = []
    
    // MVVM 아키텍처를 따르기 위해 변경사항을 감지하고 이를 뷰에 반영하기 위한 코드
    @Published var items: [(SearchModel,WeatherAPIModel)] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        configureData()
    }
    func configureData(){
        loadRecentSearch()
        callAPI()
    }
    func fetchItems() {
        items = []
        for index in 0..<searchModel.count {
            let item = (searchModel[index], weatherAPIModel[index])
            self.items.append(item)
        }
    }
    
    
    func loadRecentSearch(){
        if let savedData = UserDefaults.standard.object(forKey: "recentSearch") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([SearchModel].self, from: savedData) {
                self.searchModel = savedObject
            }
        }
    }
    
    func callAPI(){
        searchModel.forEach{ searchModelItem in
            self.group.enter()
            WebServiceManager.shared.getForecastWeather(searchModel: searchModelItem, completion: { data in
                defer { self.group.leave() }
                self.weatherAPIModel.append(data)
                
            })
        }
        self.group.notify(queue: .main) {
            self.fetchItems()
        }
    }
    
    func moveItem(from sourceIndex: Int, to destinationIndex: Int) {
            guard sourceIndex != destinationIndex else { return }
            
            // 아이템을 이동시킵니다.
            let itemToMove = items.remove(at: sourceIndex)
            items.insert(itemToMove, at: destinationIndex)
        }
    
    
}
