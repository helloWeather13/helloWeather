//
//  FineDustModel.swift
//  helloWeather
//
//  Created by 김태담 on 5/14/24.
//

import Foundation
import SwiftUI
import Charts


struct LineChartView: View {
    
    let now = Date()
    var local = "서울시 강남구 역삼동"
    var titleFontSize = 18
    @State private var isAnimating = false
    //Test 부분
    @StateObject private var fineListViewModel =
    FineListViewModel(
        weatherManager: WebServiceManager.shared,
        userLocationPoint: (37.7749, -122.4194)
    )
    
    var body: some View {
        VStack(alignment: .leading) {
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
                                self.isAnimating = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation(.easeInOut(duration: 1.0)) {
                                    self.isAnimating = false
                                }
                            }
                        }
                    Spacer()
                }
            }
            //그래프
            Text("")
                .frame(height: 100)
            //
            FineListView(viewModel: fineListViewModel)
            ValueList(viewModel: fineListViewModel)
            
        }
    }
}
#Preview {
    VStack {
        LineChartView()
    }
}
