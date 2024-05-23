import Foundation
import UIKit
import CoreLocation

protocol TempListViewModelDelegate: AnyObject {
    func didUpdateCurrentWeather(_ currentWeatherModel: SearchModel)
}

class TempListViewModel: NSObject, CLLocationManagerDelegate {
    var currentWeatherModel: SearchModel = SearchModel(keyWord: "", fullAddress: "", lat: 1.0, lon: 1.0, city: "")
    var bookMarkModel: [SearchModel] = []
    var weatherAPIModel: [WeatherAPIModel] = []
    var willDeleteSearchModel: SearchModel?
    
    // CLLocationManager 인스턴스 추가
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        loadBookMark()
        applySnapshot()
    }
    
    func loadBookMark() {
        if let savedData = UserDefaults.standard.object(forKey: "bookMark") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([SearchModel].self, from: savedData) {
                self.bookMarkModel = savedObject
            }
        }
    }
    
    func deleteBookMark() {
        guard let index = bookMarkModel.firstIndex(where: {
            $0.fullAddress == willDeleteSearchModel?.fullAddress
        }) else { return }
        bookMarkModel.remove(at: index)
        updateBookMark()
        self.applySnapshot()
    }
    
    func updateBookMark() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.bookMarkModel) {
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
        let items: [ListViewSectionItem] = bookMarkModel.map {
            .listWeather($0)
        }
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    func moveBookMark(from sourceIndex: Int, to destinationIndex: Int) {
        let movedItem = bookMarkModel.remove(at: sourceIndex)
        bookMarkModel.insert(movedItem, at: destinationIndex)
        updateBookMark()
        applySnapshot()
    }
    
    // CLLocationManagerDelegate 메서드
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            if let error = error {
                print("\(error)")
                return
            }
            
            guard let self = self, let placemark = placemarks?.first else { return }
            
            let address = [
                placemark.administrativeArea,
                placemark.subAdministrativeArea,
                placemark.locality,
                placemark.subLocality
            ].compactMap { $0 }.joined(separator: " ")
            
            self.currentWeatherModel = SearchModel(
                keyWord: "",
                fullAddress: address,
                lat: location.coordinate.latitude,
                lon: location.coordinate.longitude,
                city: address
            )
            
            self.applySnapshot()
            self.delegate?.didUpdateCurrentWeather(self.currentWeatherModel)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error)")
    }
    
    weak var delegate: TempListViewModelDelegate?
}
