//
//  FineDustModel.swift
//  helloWeather
//
//  Created by 김태담 on 5/14/24.
//

import Foundation
import SwiftUI
import Charts

struct CustomChartView {
    let labels = ["매우 나쁨", "나쁨", "보통", "좋음"]
    //let values = [1,2,3,4]
}
struct TimeData {
    let time: Date
    let value: Double
}

struct LineChartView: View {
    
    let now = Date()
    var local = "운중동"
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("\t\(local) ")
                    .font(.system(size: 16, weight: .medium))
                Text(formattedDateWithWeekdays)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
                Spacer()
            }
            // tabbar자리
            Text(" ")
                .font(.system(size: 40, weight: .medium))
            //
            HStack{
                Text("시간대별 미세먼지")
                    .font(.system(size: 16, weight: .medium))
                //.frame(maxWidth: .infinity)
                Spacer()
                Text("☑︎  등급 기준 안내       ")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }
            
        }
        .frame(height: 300)
    }
    
    private var formattedDate: String {
        createTimeFormatter().string(from: now)
    }
    
    private var formattedDateWithWeekdays: String {
        let formatter = createTimeFormatter()
        let formattedDate = formatter.string(from: now)
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: now)
        
        if let weekday = components.weekday {
            switch weekday {
            case 1:
                return formattedDate + "(일)"
            case 2:
                return formattedDate + "(월)"
            case 3:
                return formattedDate + "(화)"
            case 4:
                return formattedDate + "(수)"
            case 5:
                return formattedDate + "(목)"
            case 6:
                return formattedDate + "(금)"
            case 7:
                return formattedDate + "(토)"
            default:
                break
            }
        }
        return formattedDate
    }
    
    private func createTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH시"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    
}

#Preview {
    VStack {
        LineChartView()
    }
}
