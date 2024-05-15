//
//  File.swift
//  helloWeather
//
//  Created by 김태담 on 5/15/24.
//

import Foundation
import SwiftUI
import Charts

// 그래프 구조체
struct ChartData: Identifiable {
    var id: Int
    var date: String
    var value: Double
    var type: ChartType
}

// 2개의 구조체
enum ChartType: String, CaseIterable, Plottable {
    case optimal = "미세먼지"
    case outside = "초미세먼지"
    case white = ""
    
    var color: Color {
        switch self {
        case .optimal: return .white
        case .outside: return .white
        case .white: return .white
        }
    }
    
    var backgroudnColor: Color {
        switch self {
        case .optimal: return .green
        case .outside: return Color(red: 15/255, green: 206/255, blue: 235/255)
        case .white: return .white
        }
    }
}


// 테스트 데이타
var chartDatas : [ChartData] = {
  
    var temp = [ChartData]()
    
    for i in 1...6 {
        let value = Double.random(in: 0...0.5)
        temp.append(ChartData(id: i, date: "\(i+3*i)", value: value, type: .optimal))
    }
    
    for i in 1...6 {
        let value = Double.random(in: 0...0.5)
        temp.append(ChartData(id: i, date: "\(i+3*i)", value: value, type: .outside))
    }
    for i in 1...6 {
        let value = 2
        temp.append(ChartData(id: i, date: "\(i+3*i)", value: Double(value), type: .white))
    }
    
    return temp
}()


struct ChartView: View {
    
    //변수
    let data: [ChartData]
    let now = Date()
    let calendar = Calendar.current
    
    //함수
    func createTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal) {
                Chart {
                    ForEach(Array(data.enumerated()), id: \.element.id) { index ,item in
                        LineMark(
                            x: .value("시간", item.date),
                            y: .value("미세먼지 농도", item.value)
                        )
                        //선의 설정
                        .foregroundStyle(item.type.backgroudnColor)
                        .foregroundStyle(by: .value("Plot", item.type))
                        .interpolationMethod(.linear)
                        .lineStyle(index > 1 ? StrokeStyle(lineWidth: 2, dash: [5, 3]) : StrokeStyle(lineWidth: 2))

                    }
                }
                //.chartLegend(.hidden)
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(width: 1000)
                HStack(content: {
                    Spacer()
                    Text("지금")
                    Spacer()
                    ForEach(data) { time in
                        Text("\(time.date)시")
                        Spacer()
                    }
                    Spacer()
                })
            }
        }
    }
}

#Preview {
    VStack {
        ChartView(data: chartDatas)
            .padding()
        Spacer()
    }
}

