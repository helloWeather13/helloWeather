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
    @ObservedObject var viewModel: FineListViewModel
    var titleFontSize = 12
    var text = "좋아요!"
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading) {
                Text(viewModel.chat1)
                    .padding()
                    .background(viewModel.chat1Color)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
