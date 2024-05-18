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
    var titleFontSize = 19
    @State private var isAnimating = false
    //Test 부분
    @StateObject private var fineListViewModel =
    FineListViewModel(
        weatherManager: WebServiceManager.shared,
        userLocationPoint: (37.7749, -122.4194)
    )
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Spacer()
                Text("시간대별 미세먼지")
                    .font(.system(size: CGFloat(titleFontSize), weight: .medium))
                ForEach(0..<10) { _ in
                    Spacer()
                }
            }
            .padding(.bottom, 30)
            //미세먼지 채팅
            VStack{
                //미세먼지 text
                HStack{
                    Spacer()
                    Text("미세먼지")
                    ForEach(0..<10) { _ in
                        Spacer()
                    }
                }
                // 미세먼지 chat
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
                // 초미세먼지
                HStack{
                    ForEach(0..<10) { _ in
                        Spacer()
                    }
                    Text("초 미세먼지")
                    Spacer()
                }
                // 초미세먼지 chat
                HStack{
                    ForEach(0..<10) { _ in
                        Spacer()
                    }
                    ChatView2()
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
                    Spacer()
                }
            }
            ZStack{
                
                ScrollView(.horizontal, showsIndicators: false){
                    ZStack{
                        //ㅇㅇ
                        VStack{
                            ChartView(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391, 287.691, 285.878, 286.46, 286.252], title: "Full chart", style: Styles2.lineChartStyleOne)
                                .frame(width: 800,height: 300, alignment: .center)
                            Spacer()
                            HStack{
                                Spacer()
                                Text("지금")
                                    .bold()
                                Spacer()
                                ForEach(3..<24) { i in
                                    if i % 3 == 0 {
                                        Text("\(i)")
                                        Spacer()
                                    }
                                }
                                Text("내일")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                                Spacer()
                                ForEach(3..<24) { i in
                                    if i % 3 == 0 {
                                        Text("\(i)")
                                        Spacer()
                                    }
                                }
                                Text("모래")
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.black)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.black, lineWidth: 2)
                                    )
                            }
                            
                        }
                        //중간선
                        HStack{
                            Spacer()
                            VStack{
                                ForEach(0..<12) { i in
                                    Text("|")
                                        .bold()
                                        .foregroundColor(.black)
                                }
                            }
                            Spacer()
                        }.padding(.leading, 20)
                        HStack{
                            ForEach(0..<20) { _ in
                                Spacer()
                            }
                            VStack{
                                ForEach(0..<12) { i in
                                    Text("|")
                                        .bold()
                                        .foregroundColor(.black)
                                        .padding(.leading, 460)
                                }
                            }
                            Spacer()
                        }
                    }
//                    .contentShape(Rectangle()) // Makes the entire area tappable
//                    .gesture(DragGesture(minimumDistance: 0)
//                        .onChanged { _ in } // Handle touch events without allowing scroll
//                    )
                    
                }
                
                
            }
            FineListView(viewModel: fineListViewModel)
                .padding(.bottom, 50)
            ValueList(viewModel: fineListViewModel)
            Spacer()
        }.frame(height: 800)
    }
}
#Preview {
    VStack {
        LineChartView()
        Spacer()
    }
}
