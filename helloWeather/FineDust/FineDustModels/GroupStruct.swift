//
//  GroupStruct.swift
//  helloWeather
//
//  Created by 김태담 on 5/18/24.
//

import Foundation
import SwiftUI

// 미세먼지 상태 얼굴 타입
enum Facetype: String {
    case happy = "아주 좋음"
    case smile = "좋음"
    case umm = "보통"
    case bad = "나쁨"
    
    var image : Image{
        switch self {
        case .happy: return Image("happy")
        case .smile: return Image("smile")
        case .umm: return Image("umm")
        case .bad: return Image("bad")
        }
    }
}
