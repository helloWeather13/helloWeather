//
//  File.swift
//  helloWeather
//
//  Created by 김태담 on 5/17/24.
//

import Foundation
import SwiftUI
import Charts


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


struct FineList: View {
    @SwiftUI.State private var isToggleOn = false
    var titleFontSize = 18
    let day1 = Date()
    let day2: Date? = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    let day3: Date? = Calendar.current.date(byAdding: .day, value: 2, to: Date())
    let day4: Date? = Calendar.current.date(byAdding: .day, value: 3, to: Date())
    
    private func formattedDateWithWeekdays(date: Date) -> String {
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
    private func createTimeFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM. dd"
        // 'a' for AM/PM indicator
        //formatter.locale = Locale(identifier: "ko_KR") // Sets the locale to Korean
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
    }
    
    private func isWeekend(date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: date)
        
        if let weekday = components.weekday {
            return weekday == 1 || weekday == 7
        }
        return false
    }
    
    
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
