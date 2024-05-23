

import Foundation
import SwiftUI
import Charts


struct LineChartView: View {
    
    let now = Date()
    //var local = "서울시 강남구 역삼동"
    var titleFontSize = 19
    let homeViewModel = HomeViewModel()

    
    @State private var startPosition: CGPoint = .zero
    @State private var scrollOffset: CGFloat = 0.0
    @State private var chartMove: CGFloat = 0.0
    @State private var widtdmove: CGPoint = .zero
    @State private var chartMove2: CGFloat = 0.0
    @State private var widtdmove2: CGPoint = .zero
    @State private var isOffsetEnabled: Bool = true
    
    @State private var isTouched: Bool = false
    @State private var isAnimating = false
    @State private var isAnimating2 = false
    
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
                //print("증가")
                self.scrollOffset -= 8
            }
            if self.scrollOffset == -400{
                //print("감소")
                self.scrollOffset += 8
            }
        } else if self.chartMove < -30 {
            if self.scrollOffset < 0 {
                //print("감소")
                self.scrollOffset += 8
            }
            if self.scrollOffset == 0{
                //print("감소")
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
                
                Text("시간대별 미세먼지")
                    .font(.custom("Pretendard-Regular", size: CGFloat(titleFontSize)))
                //.font(.custom("Pretendard", size: titleFontSize))
                    .padding(.leading, 22)
                    .padding(.top, 26)
                Spacer()
            }
            .padding(.bottom, 16)
            //미세먼지 채팅
            VStack{
                // 미세먼지 chat
                HStack{
                    Text("미세먼지")
                        .font(.custom("Pretendard-Regular", size: 13))
                        .padding(.leading, 38)
                    Spacer()
                    Text("초미세먼지")
                        .font(.custom("Pretendard-Regular", size: 13))
                        .padding(.trailing, 38)
                }
                HStack{
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    // 첫 번째 애니메이션이 끝난 후 두 번째 애니메이션 시작
                                    withAnimation(.easeInOut(duration: 1.0)) {
                                        isAnimating2 = true
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                        withAnimation(.easeInOut(duration: 1.0)) {
                                            isAnimating2 = false
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.leading, 44)
                    
                    Spacer()
                    
                    ChatView2(viewModel: fineListViewModel)
                        .scaleEffect(isAnimating2 ? 1.4 : 1.0, anchor: .trailing)
                        .padding(.trailing, 44)
                }
            }.padding(.bottom, 50)
            ZStack{
                
                ScrollView(.horizontal, showsIndicators: false){
                    ZStack{
                        VStack{
                            ZStack {
                                
                                GeometryReader { geometry in
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        VStack{
                                            ZStack {
                                                ChartView2(data: fineListViewModel.returnfine(), title: "Second Chart", style: Styles2.lineChartStyleOne2, move: $chartMove2, widthmove: $widtdmove2, dragLocation: $fineListViewModel.draglocation2, currentDataNumber: $fineListViewModel.currentDataNumber2, colorline: $fineListViewModel.colorline)
                                                    .opacity(0.5)
                                                    .frame(width: geometry.size.width-30, height: geometry.size.height)
                                                ChartView(data: fineListViewModel.returnmicro(), title: "Full chart", style: Styles2.lineChartStyleOne, move: $chartMove, widthmove: $widtdmove, dragLocation: $fineListViewModel.draglocation, currentDataNumber: $fineListViewModel.currentDataNumber)
                                                    .frame(width: geometry.size.width-30, height: geometry.size.height)
                                            }
                                            .offset(x: isOffsetEnabled ? self.scrollOffset : 0) // Apply scroll offset
                                        }
                                    }
                                    .onAppear {
                                        //움직이는 동작 시작하는 위치 설정으로 마우스 커서 이동제어
                                        self.setStartPosition(in: geometry.size)
                                        self.moveScroll()
                                    }
                                    .scrollDisabled(true)
                                    .padding(.leading, -20)
                                }
            
                            }
                            .onChange(of: chartMove) {
                                moveScroll()
                            }
                            .frame(width: 800,height: 300, alignment: .center)
                        }
                       
                    }
                    
                }
                .scrollDisabled(true)
            }
            .padding(.bottom, 45)
          
            FineListView(viewModel: fineListViewModel)
                //.opacity(0.5)
                //.border(color: .gray, width: 1, opacity: opacity(0.5))
                //.padding(.to)
                .frame(height : 200)
        
            ValueList(viewModel: fineListViewModel)
            Spacer()
        }.frame(height: 1100)
    }
}

