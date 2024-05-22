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
    @ObservedObject var viewModel: FineListViewModel
    var titleFontSize = 12
    var text = "아주 좋아요!"
    
    var body: some View {
        
        ZStack{
            VStack(alignment: .leading) {
                Text(viewModel.chat2)
                    .padding()
                    .background(viewModel.chat2Color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
        }
    }
}

