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
    
    var asValuetype: Valuetype {
        return Valuetype(rawValue: self.rawValue) ?? .umm
    }
}

// 미세먼지 컬러 타입
enum Valuetype: String {
    case happy = "아주 좋음"
    case smile = "좋음"
    case umm = "보통"
    case bad = "나쁨"
    
    var color : Color{
        switch self {
        case .happy: return .blue
        case .smile: return .green
        case .umm: return .orange
        case .bad: return .red
        }
    }
}

enum Valuetype2: String {
    case happy = "아주 좋음"
    case smile = "좋음"
    case umm = "보통"
    case bad = "나쁨"
    
    static func from(value: Double) -> Valuetype2 {
        switch value {
        case 0..<15:
            return .happy
        case 15..<35:
            return .smile
        case 35..<55:
            return .umm
        default:
            return .bad
        }
    }
    
    var color: Color {
        switch self {
        case .happy: return .blue
        case .smile: return .green
        case .umm: return .orange
        case .bad: return .red
        }
    }
}

// 라벨 상태를 나타내는 구조체
struct CustomChartView {
    let labels = ["매우 나쁨", "나쁨", "보통", "좋음"]
}

// 시간을 나타내는 구조체
struct TimeData {
    let time: Date
    let value: Double
}

