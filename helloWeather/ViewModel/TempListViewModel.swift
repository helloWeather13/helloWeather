import Foundation
import UIKit


class TempListViewModel {
    var currentWeatherModel : SearchModel = SearchModel(keyWord: "sda", fullAddress: "여의동", lat: 37.521715859, lon: 126.924290018, city: "여의동")
    var searchModel : [SearchModel] = []
    var weatherAPIModel : [WeatherAPIModel] = []
    
    init(){
        loadRecentSearch()
        applySnapshot()
    }
    func loadRecentSearch(){
        if let savedData = UserDefaults.standard.object(forKey: "recentSearch") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([SearchModel].self, from: savedData) {
                self.searchModel = savedObject
            }
        }
    }
    
    var dataSource: UITableViewDiffableDataSource<ListViewSection, ListViewSectionItem>?
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ListViewSection, ListViewSectionItem>()
        snapshot.appendSections([.currentWeather])
        snapshot.appendItems([.currentWeather(self.currentWeatherModel)])
        snapshot.appendSections([.space])
        snapshot.appendItems([.space])
        snapshot.appendSections([.listWeather])
        let items:[ListViewSectionItem] = searchModel.map({
            .listWeather($0)
        })
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
}
