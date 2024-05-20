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
    
    @State private var startPosition: CGPoint = .zero
    @State private var scrollOffset: CGFloat = 0.0
    @State private var chartMove: CGFloat = 0.0
    @State private var widtdmove: CGPoint = .zero
    @State private var isOffsetEnabled: Bool = true
    
    @State private var isTouched: Bool = false
    @State private var isAnimating = false
    @State private var currentDataNumber: Double = 0
    @State private var currentDataNumber2: Double = 0

    @StateObject private var fineListViewModel =
    FineListViewModel(
        weatherManager: WebServiceManager.shared,
        userLocationPoint: (37.7749, -122.4194)
    )
    
    func moveScroll() {
        //print(chartMove)
//        print("scrolloffset \(scrollOffset)")
//        print(self.widtdmove.x + self.chartMove)
//        print(chartMove)
//        
        
        if self.chartMove > 30 {
            if self.scrollOffset > -400 {
                print("증가")
                self.scrollOffset -= 8
            }
            if self.scrollOffset == -400{
                print("감소")
                self.scrollOffset += 8
            }
        } else if self.chartMove < -30 {
            if self.scrollOffset < 0 {
                print("감소")
                self.scrollOffset += 8
            }
            if self.scrollOffset == 0{
                print("감소")
                self.scrollOffset += 8
            }
            
        }
        
        
    }
    
    func setStartPosition(in size: CGSize) {
        self.startPosition = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    func enableOffset() {
        self.isOffsetEnabled = true
    }
    
    func disableOffset() {
        self.isOffsetEnabled = false
    }
    
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
                // 미세먼지 chat
                HStack{
                    VStack{
                        Text("미세먼지")
                        ChatView(viewModel: fineListViewModel)
                            .scaleEffect(isAnimating ? 1.4 : 1.0, anchor: .leading)
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
                            .padding(.leading, 10)
                    }
                    Spacer()
                    VStack{
                        Text("초 미세먼지")
                        ChatView2(viewModel: fineListViewModel)
                            .scaleEffect(isAnimating ? 1.4 : 1.0, anchor: .trailing)
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
                            .padding(.trailing, 10)
                    }
                    
                }
                
            }
            ZStack{
                ScrollView(.horizontal, showsIndicators: false){
                    ZStack{
                        VStack{
                            ZStack {
                                GeometryReader { geometry in
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        VStack{
                                            ZStack {
                                                ChartView2(data: fineListViewModel.returnfine(), title: "Second Chart", style: Styles2.lineChartStyleOne2, currentDataNumber: $currentDataNumber)
                                                    .opacity(0.5)
                                                    .frame(width: geometry.size.width-30, height: geometry.size.height)
                                                
                                                ChartView(data: fineListViewModel.returnmicro(), title: "Full chart", style: Styles2.lineChartStyleOne, move: $chartMove, widthmove: $widtdmove, currentDataNumber: $currentDataNumber2)
                                                    .frame(width: geometry.size.width-30, height: geometry.size.height)
                                            }
                                            .offset(x: isOffsetEnabled ? self.scrollOffset : 0) // Apply scroll offset
                                        }
                                    }
                                    .onAppear {
                                        self.setStartPosition(in: geometry.size)
                                        self.moveScroll()
                                    }
                                    .scrollDisabled(true)
                                    
                                }
                            }
                            .onChange(of: chartMove) {
                                moveScroll()
                            }
                        }
                        .frame(width: 800,height: 300, alignment: .center)
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
                    
                }
                .scrollDisabled(true)
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
    }
}

