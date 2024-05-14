//
//  FineDustModel.swift
//  helloWeather
//
//  Created by 김태담 on 5/14/24.
//

import Foundation
import SwiftUI
import Charts

enum LineChartType: String, CaseIterable, Plottable {
    case optimal = "  미세 보통 42  "
    case outside = "  초미세 좋음 15  "
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

struct CustomChartView {
    let labels = ["매우 나쁨", "나쁨", "보통", "좋음"]
    let values = [1,2,3,4]
}

struct LineChartData {
    var id = UUID()
    var date: Date
    var value: Double
    var type: LineChartType
}

struct TimeData {
    let time: Date
    let value: Double
}

struct LineChartView: View {
    
    let data: [LineChartData]
    var start = 1
    
    var body: some View {
        let formatter = createTimeFormatter()
        
        VStack(alignment: .leading) {
            
            HStack{
                Text("시간대별 미세먼지")
                    .font(.system(size: 16, weight: .medium))
                //.frame(maxWidth: .infinity)
                Spacer()
                Text("☑︎  등급 기준 안내       ")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.gray)
            }
            .border(Color.gray, width: 1)
            Chart {
                ForEach(Array(data.enumerated()), id: \.element.id) { index ,item in
                    LineMark(
                        x: .value("Weekday", formatter.string(from: item.date)),
                        y: .value("Value", item.value)
                    )
                    
                    .foregroundStyle(item.type.backgroudnColor)
                    //.foregroundStyle(getLineGradient())
                    //.clipShape(Shape)
                    .foregroundStyle(by: .value("Plot", item.type))
                    .interpolationMethod(.linear)
                    .lineStyle(index > 1 ? StrokeStyle(lineWidth: 2, dash: [5, 3]) : StrokeStyle(lineWidth: 2))
                    //.lineStyle(.init(lineWidth: 1))
                    //.lineStyle(.init(.Stride))
                    .symbol {
                        if index == 1 || index == 9 {
                            Circle()
                                .fill(item.type.backgroudnColor)
                                .frame(width: 8, height: 8)
                                .overlay {
                                    Circle()
                                        .fill(item.type.color)
                                        .frame(width: 6, height: 6, alignment: .center)
                                }
                            
                            //Text("\(Int(item.value))")
                            //.frame(width: 20)
                            //.font(.system(size: 8, weight: .medium))
                            //.offset(y: -15)
                        }else{
                            EmptyView()
                        }
                    }
                }
            }
            
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .background(Color.clear)
            //.border(Color.gray, width: 1)
            .chartLegend(position: .top, alignment: .leading, spacing: -60){
                VStack(spacing: 2) {
                    ForEach(LineChartType.allCases, id: \.self) { type in
                        HStack{
                            Text(type.rawValue)
                                .foregroundStyle(type.color)
                                .padding(.top, 4)
                                .padding(.bottom, 4)
                                .font(.system(size: 13, weight: .medium))
                                .background(type.backgroudnColor)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Spacer()
                        }
                    }
                }
                
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
            .padding(.leading, 50)
            /*
             처음시작은 이제 uikit 를하려고 했는데 이쁜게 없음 1,
             그런데도 uikit하려고함 ... 사용 uikit package를 사용햇습니다.
             커스템 그래프 그래도 쓰지 못함 그래서 커스텀을 해야하는데
             커스템 메소드 지원해지주지 않음
             그 페이키 수정해야하는데 접근하려고 접근 권한도 안줌
             안의 내용을 볼서 없음
             튜터 갔떠니 예전 자신 똑같은 접근제한 커스텀못한다.
             만들어야된다. 직접만들려고하는데 실패 버려
             cocoapod ,opensource에서 때어와서 사용할렸는데
             uikit 예전거 뿐이고 해보니까 swift 더 잘짜여있어
             cocoapod사용했는데 m3칩 ruby 발동!!!
             그래서 억까 packageManger => 이런 전번 있었다.
             M3이슈 swift ui밖에없다.
             */
            HStack{
                Spacer()
            }
            //.border(Color.gray, width: 1)
            .chartXAxis {
                AxisMarks(preset: .extended, values: .stride (by: .hour, count: 3)) { value in
                    AxisValueLabel(format: .dateTime.hour())
                }
            }
            .chartYAxis {
            }
            .padding(.leading, 60)
            
        }
        .frame(height: 300)
        Label("Welcome to SwiftUI", systemImage: "star.fill")
            .padding() // 패딩을 추가하여 라벨 주변에 공간을 만듭니다.
            .background(Color.blue) // 배경색을 파란색으로 설정합니다.
            .foregroundColor(.white) // 전경색을 흰색으로 설정합니다.
            .cornerRadius(10)
            .border(Color.gray, width: 1)
    }
    
    
    //    func getLineGradient() -> LinearGradient {
    //        return LinearGradient(
    //            stops: [
    //                .init(color: .red, location: 0),
    //                .init(color: .green, location: 0.1),
    //                .init(color: .yellow, location: 0.3),
    //                .init(color: .blue, location: 0.5),
    //                .init(color: .orange, location: 0.8),
    //                .init(color: .black, location: 1),
    //            ],
    //            startPoint: .leading,
    //            endPoint: .bottomTrailing
    //        )
    //    }
    func createTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH시"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    
    func generateTimeData() -> [TimeData] {
        var results = [TimeData]()
        let now = Date()
        let calendar = Calendar.current
        
        for hourOffset in stride(from: 0, to: 24, by: 3) {
            if let date = calendar.date(byAdding: .hour, value: hourOffset, to: now) {
                results.append(TimeData(time: date, value: Double.random(in: 0...100)))
            }
        }
        
        return results
    }
    
}

var chartData : [LineChartData] = {
    let now = Date()
    let calendar = Calendar.current
    let sampleDate = calendar.date(byAdding: .hour, value: 0, to: now)!
    var temp = [LineChartData]()
    
    // Line 1
    for i in 0..<8 {
        let value = Double.random(in: 0.5...1)
        temp.append(
            LineChartData(
                date: sampleDate.adding(.hour, value: i)!,
                value: value,
                type: .outside
            )
        )
    }
    
    // Line 2
    for i in 0..<8 {
        let value = Double.random(in: 0.5...1)
        temp.append(
            LineChartData(
                date: sampleDate.adding(.hour, value: i)!,
                value: value,
                type: .optimal
            )
        )
    }
    
    
    // Line 3
    for i in 0..<8 {
        let value = Double.random(in: 0...1)
        temp.append(
            LineChartData(
                date: sampleDate.adding(.hour, value: i)!,
                value: 3,
                type: .white
            )
        )
    }
    
    return temp
}()


#Preview {
    VStack {
        LineChartView(data: chartData)
            .padding()
        Spacer()
    }
}

extension Date {
    func adding (_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date? {
        return calendar.date(byAdding: component, value: value, to: self)
    }
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}
