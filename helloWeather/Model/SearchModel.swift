import Foundation

struct SearchModel : Hashable, Codable {
    var keyWord : String
    var fullAddress : String
    var lat: Double
    var lon: Double
}

