import Foundation

struct KakaoAddressModel : Codable {
    let documents : [Document]
}

struct Document: Codable {
    let address: Address
}

struct Address: Codable {
    let regionNameFirst: String // 지역 1 Depth, 시도 단위
    let regionNameSecond: String // 지역 2 Depth, 구 단위
    let regionNameThird: String // 지역 3 Depth, 동 단위
    let lat: String // 위도 latitute
    let lon: String // 경도 longitude
    
    enum CodingKeys: String, CodingKey {
        case regionNameFirst = "region_1depth_name"
        case regionNameSecond = "region_2depth_name"
        case regionNameThird = "region_3depth_name"
        case lon = "x"
        case lat = "y"
    }
}
