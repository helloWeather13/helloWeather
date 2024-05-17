//
//  File.swift
//  helloWeather
//
//  Created by 김태담 on 5/17/24.
//

import Foundation
import SwiftUI
import Charts

struct FineList: View {
    
    //가져와야하는 데이터
    //데이터가 어떻게 들어오는지 확인한 후 결정
    //helloWeather.AirQuality(micro: Optional(36.1), fine: Optional(22.9))
    
    // 텍스트 포튼 크기
    var titleFontSize = 18
    let day1 = Date()
    let day2: Date? = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    let day3: Date? = Calendar.current.date(byAdding: .day, value: 2, to: Date())
    let day4: Date? = Calendar.current.date(byAdding: .day, value: 3, to: Date())
    @SwiftUI.State private var isToggleOn = false
    
    var body: some View {
        VStack(content: {
            HStack(content: {
                Spacer()
                Text("주간 미세먼지")
                    .font(.system(size: CGFloat(titleFontSize), weight: .bold))
                ForEach(0..<10) { _ in
                    Spacer()
                }
                Toggle("", isOn: $isToggleOn)
                    .toggleStyle(CustomToggleStyle())
                    .opacity(0.7)
            })
            
            HStack{
                Spacer()
                VStack{
                    Text(formattedDateWithWeekdays(date: day1))
                        .foregroundColor(isWeekend(date: day1) ? .red : .black)
                    Text(createTimeFormatter().string(from: day1))
                    Image("smile")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize*2) ,height: CGFloat(titleFontSize*2))
                    
                    
                }
                Spacer()
                VStack{
                    Text(formattedDateWithWeekdays(date: day2!))
                        .foregroundColor(isWeekend(date: day2!) ? .red : .black)
                    Text(createTimeFormatter().string(from: day2!))
                    Image("happy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize*2) ,height: CGFloat(titleFontSize*2))
                    
                }
                Spacer()
                VStack{
                    Text(formattedDateWithWeekdays(date: day3!))
                        .foregroundColor(isWeekend(date: day3!) ? .red : .black)
                    Text(createTimeFormatter().string(from: day3!))
                    Image("umm")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize*2) ,height: CGFloat(titleFontSize*2))
                    
                }
                Spacer()
                VStack{
                    Text(formattedDateWithWeekdays(date: day4!))
                        .foregroundColor(isWeekend(date: day4!) ? .red : .black)
                    Text(createTimeFormatter().string(from: day4!))
                    Image("sad")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: CGFloat(titleFontSize*2) ,height: CGFloat(titleFontSize*2))
                    
                }
                Spacer()
            }
        })
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ZStack {
                Rectangle()
                    .frame(width: 90, height: 30)
                    .foregroundColor(.gray)
                    .cornerRadius(8)
                Rectangle()
                    .cornerRadius(4)
                    .frame(width: 42, height: 24)
                    .foregroundColor(.white)
                    .padding()
                    .offset(x: configuration.isOn ? 20 : -20)
                    .animation(.easeInOut(duration: 0.1), value: configuration.isOn)
                HStack {
                    Text("미세")
                        .foregroundColor(configuration.isOn ? .white : .black)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.leading, 14)
                    
                    Spacer()
                    
                    Text("초미세")
                        .foregroundColor(configuration.isOn ? .black : .white)
                        .font(.system(size: 12, weight: .bold))
                        .padding(.trailing, 8)
                }
                .frame(width: 90, height: 30)
            }
            .onTapGesture {
                configuration.isOn.toggle()
            }
        }
        .padding()
        
    }
}


#Preview {
    VStack {
        Spacer()
        FineList()
            .padding()
        Spacer()
    }
}
