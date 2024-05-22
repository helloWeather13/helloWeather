import SwiftUI
import SwiftUICharts
import Charts

public struct ChartView: View {
    @ObservedObject var data: ChartData
    
    public var title: String?
    public var legend: String?
    public var style: ChartStyle2
    public var darkModeStyle: ChartStyle2
    public var valueSpecifier: String
    public var legendSpecifier: String
    @Binding public var move: CGFloat
    @Binding public var widthmove: CGPoint
    
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    @State public var dragLocation:CGPoint = .zero
    @State public var indicatorLocation:CGPoint = .zero
    @State public var closestPoint: CGPoint = .zero
    @State public var opacity:Double = 0
    @State private var currentDataNumber: Double = 0
    @State public var hideHorizontalLines: Bool = false
 
    
    public init(data: [Double],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle2 = Styles2.lineChartStyleOne2,
                valueSpecifier: String? = "%.1f",
                legendSpecifier: String? = "%.1f",
                move: Binding<CGFloat>,
                widthmove: Binding<CGPoint>
    
                )
    
    
    {
        
        self.data = ChartData(points: data)
        self.title = nil
        self.legend = legend
        self.style = style
        self.valueSpecifier = valueSpecifier!
        self.legendSpecifier = legendSpecifier!
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles2.lineViewDarkMode
        self._move = move
        self._widthmove = widthmove
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(floor((toPoint.x-15)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentDataNumber = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
    
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                ZStack{
                    GeometryReader{ reader in
                        //배경색까
                        Rectangle()
                            .foregroundColor(Color.clear)
                        if(self.showLegend){
                        }
                        Line2(data: self.data,
                              frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height + 25)),
                              touchLocation: self.$indicatorLocation,
                              showIndicator: self.$hideHorizontalLines,
                              minDataValue: .constant(nil),
                              maxDataValue: .constant(nil),
                              showBackground: false,
                              gradient: self.style.gradientColor
                        )
                        .offset(x: 30, y: 0)
                        .onAppear(){
                            self.showLegend = true
                        }
                        .onDisappear(){
                            self.showLegend = false
                        }
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 180)
                    .offset(x: 0, y: 40)
                    MagnifierRect(currentNumber: self.$currentDataNumber, valueSpecifier: self.valueSpecifier)
                        .opacity(0.2)
                        .offset(x: self.dragLocation.x - geometry.frame(in: .local).size.width/2, y: 36)
                }
                .frame(width: geometry.frame(in: .local).size.width, height: 240)
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.move = value.translation.width
                        self.widthmove = value.startLocation
                        print( self.move)
                        print( self.widthmove)
                        
                        print("시간위치 \(value.startLocation)")
                        print("트렌스 \(value.translation)")
                        print("위치 \(value.location)")
                        print("end \(value.predictedEndLocation)")
                        print()
                        self.dragLocation = value.location
                        self.indicatorLocation = CGPoint(x: max(value.location.x-30,0), y: 32)
                        self.opacity = 1
                        self.closestPoint = self.getClosestDataPoint(toPoint: value.location, width: geometry.frame(in: .local).size.width-30, height: 240)
                        //closestPoint추가하기
                        self.hideHorizontalLines = true
                    })
                        .onEnded({ value in
                            self.opacity = 0
                            self.hideHorizontalLines = false
                        })
                )
                HStack {
                    Spacer()
                    Text("지금")
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                    
                    ForEach(3..<24) { i in
                        if i % 3 == 0 {
                            Text("\(i)")
                                .foregroundColor(.black)
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
                                .foregroundColor(.black)
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
        }
    }
    
}

public struct ChartView2: View {
    @ObservedObject var data: ChartData
    public var title: String?
    public var legend: String?
    public var style: ChartStyle2
    public var darkModeStyle: ChartStyle2
    public var valueSpecifier: String
    public var legendSpecifier: String
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    @State private var dragLocation:CGPoint = .zero
    @State private var indicatorLocation:CGPoint = .zero
    @State private var closestPoint: CGPoint = .zero
    @State private var opacity:Double = 0
    @State private var currentDataNumber: Double = 0
    @State private var hideHorizontalLines: Bool = false
    
    public init(data: [Double],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle2 = Styles2.lineChartStyleOne,
                valueSpecifier: String? = "%.1f",
                legendSpecifier: String? = "%.1f") {
        
        self.data = ChartData(points: data)
        self.title = nil
        self.legend = legend
        self.style = style
        self.valueSpecifier = valueSpecifier!
        self.legendSpecifier = legendSpecifier!
        self.darkModeStyle = style.darkModeStyle != nil ? style.darkModeStyle! : Styles2.lineViewDarkMode
    }
    
    func getClosestDataPoint(toPoint: CGPoint, width:CGFloat, height: CGFloat) -> CGPoint {
        let points = self.data.onlyPoints()
        let stepWidth: CGFloat = width / CGFloat(points.count-1)
        let stepHeight: CGFloat = height / CGFloat(points.max()! + points.min()!)
        
        let index:Int = Int(floor((toPoint.x-15)/stepWidth))
        if (index >= 0 && index < points.count){
            self.currentDataNumber = points[index]
            return CGPoint(x: CGFloat(index)*stepWidth, y: CGFloat(points[index])*stepHeight)
        }
        return .zero
    }
    
    public var body: some View {
        GeometryReader{ geometry in
            VStack(alignment: .leading, spacing: 8) {
                ZStack{
                    GeometryReader{ reader in
                        //줄 선
                        MagnifierRect(currentNumber: self.$currentDataNumber, valueSpecifier: self.valueSpecifier)
                            .opacity(self.opacity)
                            .offset(x: self.dragLocation.x - geometry.frame(in: .local).size.width/2, y: 36)
                        Rectangle()
                            .foregroundColor(self.colorScheme == .dark ? self.darkModeStyle.backgroundColor : self.style.backgroundColor)
                        if(self.showLegend){
                        }
                        Line3(data: self.data,
                              frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height + 25)),
                              touchLocation: self.$indicatorLocation,
                              showIndicator: self.$hideHorizontalLines,
                              minDataValue: .constant(nil),
                              maxDataValue: .constant(nil),
                              showBackground: false,
                              gradient: self.style.gradientColor
                        )
                        .offset(x: 30, y: 0)
                        .onAppear(){
                            self.showLegend = true
                        }
                        .onDisappear(){
                            self.showLegend = false
                        }
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 180)
                    .offset(x: 0, y: 40)
                }
                .frame(width: geometry.frame(in: .local).size.width, height: 240)
                //                .gesture(DragGesture()
                //                    .onChanged({ value in
                //                        self.dragLocation = value.location
                //                        self.indicatorLocation = CGPoint(x: max(value.location.x-30,0), y: 32)
                //                        self.opacity = 1
                //                        self.closestPoint = self.getClosestDataPoint(toPoint: value.location, width: geometry.frame(in: .local).size.width-30, height: 240)
                //                        self.hideHorizontalLines = true
                //                    })
                //                        .onEnded({ value in
                //                            self.opacity = 0
                //                            self.hideHorizontalLines = false
                //                        })
                //                )
            }
        }
    }
    
}

struct ContentViewTest: View {
    @State private var startPosition: CGPoint = .zero
    @State private var scrollOffset: CGFloat = 0.0
    @State private var chartMove: CGFloat = 0.0
    @State private var widtdmove: CGPoint = .zero
    @State private var isOffsetEnabled: Bool = true


    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    VStack{
                        ZStack {
                            ChartView2(data: [300.0, 305.0, 290.0, 295.0, 310.0, 315.0, 320.0, 325.0, 330.0, 335.0, 340.0, 345.0,300.0, 305.0, 290.0, 295.0, 310.0, 315.0, 320.0, 325.0, 330.0, 335.0, 340.0, 345.0,300.0, 305.0, 290.0, 295.0, 310.0, 315.0, 320.0, 325.0, 330.0, 335.0, 340.0, 345.0,300.0, 305.0, 290.0, 295.0, 310.0, 315.0, 320.0, 325.0, 330.0, 335.0, 340.0, 345.0,300.0, 305.0, 290.0, 295.0, 310.0, 315.0, 320.0, 325.0, 330.0, 335.0, 340.0, 345.0], title: "Second Chart", style: Styles2.lineChartStyleOne2)
                                .opacity(0.5)
                                .frame(width: geometry.size.width-30, height: geometry.size.height)
                            
                            ChartView(data: [282.502, 284.495, 283.51, 285.019, 285.197, 286.118, 288.737, 288.455, 289.391,300.0, 305.0, 290.0, 295.0, 310.0, 315.0, 320.0, 325.0, 330.0, 335.0, 340.0, 345.0,300.0, 305.0, 290.0, 295.0, 310.0, 315.0, 320.0, 325.0, 330.0, 335.0, 340.0, 345.0,300.0, 305.0, 290.0, 295.0, 310.0, 315.0, 320.0, 325.0, 330.0, 335.0, 340.0, 345.0], title: "Full chart", style: Styles2.lineChartStyleOne, move: $chartMove, widthmove: $widtdmove)
                                .frame(width: geometry.size.width-30, height: geometry.size.height)
                        }
                        .offset(x: isOffsetEnabled ? self.scrollOffset : 0) // Apply scroll offset
                    }
                }
                .onAppear {
                    self.setStartPosition(in: geometry.size)
                    //self.chartMove = value.translation.width
                    self.moveScroll()
                }
                .scrollDisabled(true)
                
            }
        }
        .onChange(of: chartMove) {
                   moveScroll()
        }
    }

    func moveScroll() {
        //print(chartMove)
        print("scrolloffset \(scrollOffset)")
        print(self.widtdmove.x + self.chartMove)
        print(chartMove)
       
         
                if self.chartMove > 30 {
                    if self.scrollOffset > -400 {
                        self.scrollOffset -= 8
                    }// Adjust scrolling amount as needed
                } else if self.chartMove < -30 {
                    if self.scrollOffset > 400 {
                        self.scrollOffset += 8 // Adjust scrolling amount as needed
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
}

struct LineView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal) {
            VStack {
                ContentViewTest()
                    .frame(width: 800, height: 280, alignment: .center)
            }
        }
        .scrollDisabled(true)
    }
}
