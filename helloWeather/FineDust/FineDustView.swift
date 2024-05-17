//
//  FineDustView.swift
//  helloWeather
//
//  Created by 김태담 on 5/14/24.
//

import Foundation
import SwiftUI
import Charts

struct ScrollChartView: View {
    
    let now = Date()
    var local = "서울시 강남구 역삼동"
    var titleFontSize = 18
    @State private var isAnimating = false
    
    private var formattedDate: String {
        createTimeFormatter().string(from: now)
    }
    private var formattedDateWithWeekdays: String {
        //let formatter = createTimeFormatter()
        //let formattedDate = formatter.string(from: now)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: now)
        
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
    private func createTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM. dd \(formattedDateWithWeekdays) HH:mm a" // 'a' for AM/PM indicator
        //formatter.locale = Locale(identifier: "ko_KR") // Sets the locale to Korean
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    
    var body: some View {
        ScrollView {
            LineChartView()
                .frame(height: 700)
        }
    }
    
}

#Preview {
    VStack {
        ScrollChartView()
    }
}

