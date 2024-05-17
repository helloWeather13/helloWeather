//
//  File.swift
//  helloWeather
//
//  Created by 김태담 on 5/17/24.
//
import Foundation
import SwiftUI
import Charts

struct ChatView2: View {
    
    var titleFontSize = 10
    var text = "아주 좋아요!"
    
    var body: some View {
                 
        ZStack{
            HStack {
                Text(text)
                    .font(.system(size: 1, weight: .light))
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.leading, 80+CGFloat(text.count)*5)
            .padding(.bottom,15)
            HStack {
                Text(text)
                    .font(.system(size: 1, weight: .light))
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }
            .padding(.leading, 100+CGFloat(text.count)*5)
            .padding(.bottom, 5)
            VStack(alignment: .leading) {
                Text(text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    VStack {
        Spacer()
        ChatView2()
            .padding()
        Spacer()
    }
}
