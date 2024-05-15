//
//  HomeViewModel.swift
//  helloWeather
//
//  Created by CaliaPark on 5/15/24.
//

import UIKit
import CoreLocation

enum ConditionText: String {
    case rain = "비"
    case snow = "눈"
    case typhoon = "태풍"
    case none = "해"
    
    var detail: (icon: UIImage, verb: String) {
        switch self {
        case .rain:
            return (UIImage(systemName: "umbrella")!, "가 올거에요")
        case .snow:
            return (UIImage(systemName: "umbrella")!, "이 올거에요")
        case .typhoon:
            return (UIImage(systemName: "umbrella")!, "이 불거에요")
        case .none:
            return (UIImage(systemName: "umbrella")!, "가 떠있어요")
        }
    }
    
    var icon: UIImage {
        return detail.icon
    }
    
    var verb: String {
        return detail.verb
    }
}

class HomeViewModel: NSObject, CLLocationManagerDelegate {
    
    let webServiceManager = WebServiceManager.shared
    let userLocationManager = CLLocationManager()
    
    var userLocationString: String = "dd"
    
    var yesterdayString: String {
        switch difference {
        case 0:
            return "어제와"
        default:
            return "어제보다"
        }
    }
    
    var difference: Int = 0   // 오늘 - 어제
    
    var lessMoreString: String {
        switch difference {
        case ..<0:
            return "도 낮고"
        case 0:
            return "비슷하고"
        default:
            return "도 높고"
        }
    }
    
    var condition: ConditionText?
    
    override init() {
        super.init()
        userLocationManager.delegate = self
        userLocationManager.distanceFilter = kCLDistanceFilterNone
        userLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        userLocationManager.requestWhenInUseAuthorization()
        userLocationManager.startUpdatingLocation()
        getUserLocation { address in
            self.userLocationString = address
        }
        userLocationManager.stopUpdatingLocation()
    }
    
    func getUserLocation(completion: @escaping (String) -> ()) {
        let geocoder = CLGeocoder()
        
        let location = self.userLocationManager.location
        
        if let location = location {
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil { return }
                
                if let placemark = placemarks?.first {
                    var address = ""
                    
                    if let administrativeArea = placemark.administrativeArea{
                        address += "\(administrativeArea) "
                        print(administrativeArea)
                    }
                    
                    if let subAdministrativeArea = placemark.subAdministrativeArea {
                        address += "\(subAdministrativeArea) "
                        print(subAdministrativeArea)
                    }
                    
                    if let subLocality = placemark.subLocality {
                        address += "\(subLocality)"
                        print(subLocality)
                    }
                    print(address)
                    completion(address)
                } else {
                    print("No location")
                    completion("")
                }
            }
        }
    }
}
