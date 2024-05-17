//
//  File.swift
//  helloWeather
//
//  Created by 김태담 on 5/17/24.
//
import Foundation
import SwiftUI
import Charts

struct ChatView: View {
    
    var titleFontSize = 10
    var text = "좋아요!"
    
    var body: some View {
        ZStack{
            HStack {
                Text(text)
                    .font(.system(size: 1, weight: .light))
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.trailing, 60+CGFloat(text.count)*5)
            .padding(.bottom,15)
            HStack {
                Text(text)
                    .font(.system(size: 1, weight: .light))
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding(.trailing, 80+CGFloat(text.count)*5)
            .padding(.bottom, 5)
            VStack(alignment: .leading) {
                Text(text)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ChatView()
            .padding()
        Spacer()
    }
}
