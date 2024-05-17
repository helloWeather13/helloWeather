//
//  ValueList.swift
//  helloWeather
//
//  Created by 김태담 on 5/17/24.
//
import Foundation
import SwiftUI
import Charts


enum Valuetype: String {
    case happy = "아주 좋음"
    case smile = "좋음"
    case umm = "보통"
    case bad = "나쁨"
    
    var color : Color{
        switch self {
        case .happy: return .blue
        case .smile: return .green
        case .umm: return .orange
        case .bad: return .red
        }
    }
}


struct ValueList: View {
    
    var test: [Valuetype] = [
        .happy,
        .smile,
        .umm,
        .bad
    ]
    
    
    var body: some View {
        let testvalue = ["0.063", "0.009", "0.300", "0.003"]
        VStack{
            HStack{
                Spacer()
                Text("대기오염 물질")
                    .font(.system(size: 18, weight: .medium))
                ForEach(0..<8){ _ in
                    Spacer()
                }
            }
            .padding(.bottom, 20)
            ZStack{
                HStack{
                    Spacer()
                    VStack(alignment: .leading){
                        Text("오존")
                        HStack{
                            Text(test[0].rawValue)
                                .foregroundColor(test[0].color)
                            Text(testvalue[0] + "ppm")
                                .foregroundColor(test[0].color)
                        }
                    }
                    ForEach(0..<14){ _ in
                        Spacer()
                    }
                }
                HStack{
                    ForEach(0..<5){ _ in
                        Spacer()
                    }
                    VStack(alignment: .leading){
                        Text("이산화질소")
                        HStack{
                            Text(test[1].rawValue)
                                .foregroundColor(test[1].color)
                            Text(testvalue[1] + "ppm")
                                .foregroundColor(test[1].color)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
            ZStack{
                HStack{
                    Spacer()
                    VStack(alignment: .leading){
                        Text("일산화탄소")
                        HStack{
                            Text(test[2].rawValue)
                                .foregroundColor(test[2].color)
                            Text(testvalue[2] + "ppm")
                                .foregroundColor(test[2].color)
                        }
                    }
                    ForEach(0..<14){ _ in
                        Spacer()
                    }
                }
                HStack{
                    ForEach(0..<5){ _ in
                        Spacer()
                    }
                    VStack(alignment: .leading){
                        Text("아황산가스")
                        HStack{
                            Text(test[3].rawValue)
                                .foregroundColor(test[3].color)
                            Text(testvalue[3] + "ppm")
                                .foregroundColor(test[3].color)
                        }
                    }
                    Spacer()
                }
            }
            .padding()
        }
    }
}


#Preview {
    VStack {
        Spacer()
        ValueList()
            .padding()
        Spacer()
    }
}
