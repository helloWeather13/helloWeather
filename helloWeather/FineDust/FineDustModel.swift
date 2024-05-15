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
                Text(formattedDate)
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
            HStack{
                VStack(alignment: .trailing)  {
                    Text("매우나쁨")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.bottom, 6)
                    Text("나쁨")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.bottom, 6)
                    Text("보통")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.bottom, 6)
                    Text("좋음")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                .padding(.leading, 10)
                .padding(.trailing, 20)
              
                //.frame(maxWidth: .infinity)
                Spacer()
                //스크롤뷰 삽입
                ChartView(data: chartDatas)
            }
            
            
        }
        .frame(height: 300)
    }
    
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
    
}

#Preview {
    VStack {
        LineChartView()
        Spacer()
    }
}
