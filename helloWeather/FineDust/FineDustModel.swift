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
        VStack(alignment: .leading) {
            ZStack{
                HStack{
                    Spacer()
                    Text("\(local) ")
                        .font(.system(size: CGFloat(titleFontSize), weight: .medium))
                    Spacer()
                }
                HStack{
                    ForEach(0..<9) { _ in
                        Spacer()
                    }
                    Image("search_1")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize) ,height: CGFloat(titleFontSize))
                    
                    Spacer()
                }
            }
            // tabbar자리
            Text(" ")
                .font(.system(size: 40, weight: .medium))
            //
            HStack{
                Spacer()
                Text("시간대별 미세먼지")
                    .font(.system(size: CGFloat(titleFontSize-2), weight: .medium))
                ForEach(0..<10) { _ in
                    Spacer()
                }
            }
            .padding(.bottom, 10)
            //미세먼지
            VStack{
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        Text("미세먼지")
                        ForEach(0..<2) { _ in
                            Spacer()
                        }
                    }
                    .font(.system(size: CGFloat(titleFontSize-5), weight: .light))
                    ForEach(0..<10) { _ in
                        Spacer()
                    }
                    
                }
                HStack{
                    Spacer()
                    ChatView()
                        .scaleEffect(isAnimating ? 1.8 : 1.0, anchor: .leading)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    isAnimating = false
                                }
                            }
                        }
                    ForEach(0..<10) { _ in
                        Spacer()
                    }
                }
            }
            //초미세먼치 chat
            VStack{
                HStack{
                    ForEach(0..<10) { _ in
                        Spacer()
                    }
                    VStack{
                        Spacer()
                        Text("초 미세먼지")
                        ForEach(0..<2) { _ in
                            Spacer()
                        }
                    }
                    .font(.system(size: CGFloat(titleFontSize-5), weight: .light))
                    Spacer()
                    
                }
                HStack{
                    ForEach(0..<10) { _ in
                        Spacer()
                    }
                    ChatView2()
                        .scaleEffect(isAnimating ? 1.8 : 1.0, anchor: .trailing)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    isAnimating = false
                                }
                            }
                        }
                    Spacer()
                }
            }
            //그래프
           
            
            
        }
        .frame(height: 300)
    }
    
}

#Preview {
    VStack {
        LineChartView()
        Spacer()
    }
}
