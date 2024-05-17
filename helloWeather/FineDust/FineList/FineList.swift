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
    
    @State private var isToggleOn = false
    var titleFontSize = 18
    let now = Date()
   
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
        formatter.dateFormat = "\(formattedDateWithWeekdays)\n MM.dd" // 'a' for AM/PM indicator
        //formatter.locale = Locale(identifier: "ko_KR") // Sets the locale to Korean
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter
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
                Text()
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
