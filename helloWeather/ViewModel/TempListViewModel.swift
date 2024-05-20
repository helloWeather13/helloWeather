import Foundation
import UIKit


class TempListViewModel {
    var currentWeatherModel : SearchModel = SearchModel(keyWord: "sda", fullAddress: "여의동", lat: 37.521715859, lon: 126.924290018, city: "여의동")
    var bookMarkModel : [SearchModel] = []
    var weatherAPIModel : [WeatherAPIModel] = []
    var willDeleteSearchModel : SearchModel?
    
//    init(){
//        loadBookMark()
//        applySnapshot()
//    }
    func loadBookMark(){
        // RecentSearch가 아니라 바껴야 함
        if let savedData = UserDefaults.standard.object(forKey: "bookMark") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([SearchModel].self, from: savedData) {
                self.bookMarkModel = savedObject
            }
        }
    }
    func deleteBookMark(){
        guard let index = bookMarkModel.firstIndex(where: {
            $0.fullAddress == willDeleteSearchModel?.fullAddress
        }) else {return}
        bookMarkModel.remove(at: index)
        updateBookMark()
        self.applySnapshot()
    }
    
    func updateBookMark() {
        // RecentSearch가 아니라 바껴야 함
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.bookMarkModel){
            UserDefaults.standard.setValue(encoded, forKey: "bookMark")
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
        let items:[ListViewSectionItem] = bookMarkModel.map({
            .listWeather($0)
        })
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
