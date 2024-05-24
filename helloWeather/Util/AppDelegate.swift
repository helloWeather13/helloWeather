import UIKit
import CoreLocation
import WidgetKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var locationManager: CLLocationManager!

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        return true
    }
}

extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first, error == nil {
                var address = ""
                
                if let subLocality = placemark.subLocality {
                    address = "\(subLocality)"
                }else{
                    if let subAdministrativeArea = placemark.subAdministrativeArea {
                        address = "\(subAdministrativeArea) "
                    }
                }

                let searchModel = SearchModel(keyWord: "", fullAddress: address, lat: lat, lon: lon, city: address)
                let userDefaults = UserDefaults(suiteName: "group.com.seungwon.helloWeather")
                userDefaults?.set(try? PropertyListEncoder().encode(searchModel), forKey: "currentSearchModel")
                WidgetCenter.shared.reloadTimelines(ofKind: "HelloWeatherWidget")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }
}
