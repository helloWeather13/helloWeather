//
//  FineDustUtil.swift
//  helloWeather
//
//  Created by 김태담 on 5/18/24.
//

import Foundation

//MARK: - 주말에 해당하는 요일을 반환 해줍니다.
func formattedDateWithWeekdays(date: Date) -> String {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.weekday], from: date)
    
    if let weekday = components.weekday {
        switch weekday {
        case 1:
            return "(일)"
        case 2:
            return "(월)"
        case 3:
            return "(화)"
        case 4:
            return "(수)"
        case 5:
            return "(목)"
        case 6:
            return "(금)"
        default:
            return "(토)"
        }
    }
    return ""
}

//MARK: - 한국 시간과 원하는 형식에 맞게 데이터 포맷형태를 반환해 줍니다.
func createTimeFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "MM. dd"
    formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
    return formatter
}

//MARK: - 주말인지 아니지를 판별 해줍니다.
func isWeekend(date: Date) -> Bool {
    let calendar = Calendar(identifier: .gregorian)
    let components = calendar.dateComponents([.weekday], from: date)
    
    if let weekday = components.weekday {
        return weekday == 1 || weekday == 7
    }
    return false
}
//MARK: - 3자리수 변환 해줍니다.
func formatToThreeDecimalPlaces(value: Double?) -> String {
    guard let value = value else { return "N/A" }
    
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 3
    formatter.minimumFractionDigits = 3
    
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
}
