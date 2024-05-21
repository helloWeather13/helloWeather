import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentSearchModel: SearchModel? = nil
    private var locationUpdateHandler: ((SearchModel) -> Void)? = nil

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        returnCurrentSearchModel(location: location)
        manager.stopUpdatingLocation()
    }
    
    private func returnCurrentSearchModel(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            if error != nil { return }
            if let placemark = placemarks?.first {
                let lat = placemark.location?.coordinate.latitude ?? 0
                let lon = placemark.location?.coordinate.longitude ?? 0
                var address = ""
                if let administrativeArea = placemark.administrativeArea {
                    address += "\(administrativeArea) "
                }
                if let subAdministrativeArea = placemark.subAdministrativeArea {
                    address += "\(subAdministrativeArea) "
                }
                if let subLocality = placemark.subLocality {
                    address += "\(subLocality)"
                }
                let searchModel = SearchModel(keyWord: "", fullAddress: address, lat: lat, lon: lon, city: address)
                self.currentSearchModel = searchModel
                self.locationUpdateHandler?(searchModel)
            } else {
                print("No location")
            }
        }
    }

    func setLocationUpdateHandler(_ handler: @escaping (SearchModel) -> Void) {
        self.locationUpdateHandler = handler
        if let currentLocation = self.currentSearchModel {
            handler(currentLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
