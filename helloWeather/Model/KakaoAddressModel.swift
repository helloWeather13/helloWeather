import Foundation

struct KakaoAddressModel : Codable, Hashable {
    let documents : [Document]
}

struct Document: Codable, Hashable {
    let address: Address
}

struct Address: Codable , Hashable{
    let regionNameFirst: String // 지역 1 Depth, 시도 단위
    let regionNameSecond: String // 지역 2 Depth, 구 단위
    let regionNameThird: String // 지역 3 Depth, 동 단위
    let regionNameThirdH: String // 지역 3 Depth, 동 단위
    let lat: String // 위도 latitute
    let lon: String // 경도 longitude
    
    enum CodingKeys: String, CodingKey {
        case regionNameFirst = "region_1depth_name" // 시도 단위
        case regionNameSecond = "region_2depth_name" // 구 단위
        case regionNameThird = "region_3depth_name" // 동 단위
        case regionNameThirdH = "region_3depth_h_name" // 행정동 명칭
        case lon = "x"
        case lat = "y"
    }
}
