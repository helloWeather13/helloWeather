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
    @Binding public var currentDataNumber: Double
    @Binding public var dragLocation:CGPoint
    
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    //@State public var dragLocation:CGPoint = .zero
    @State public var indicatorLocation:CGPoint = .zero
    @State public var closestPoint: CGPoint = .zero
    @State public var opacity:Double = 0
    @State public var hideHorizontalLines: Bool = false
    
    
    public init(data: [Double],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle2 = Styles2.lineChartStyleOne2,
                valueSpecifier: String? = "%.1f",
                legendSpecifier: String? = "%.1f",
                move: Binding<CGFloat>,
                widthmove: Binding<CGPoint>,
                dragLocation: Binding<CGPoint>,
                currentDataNumber: Binding<Double>
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
        self._currentDataNumber = currentDataNumber
        self._dragLocation = dragLocation
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
                    Text("\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |")
                        .foregroundColor(Color.black)
                        .padding(.leading, 50)
                    Text("\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |\n |")
                        .foregroundColor(Color.black)
                        .padding(.leading, 730)
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
                              maxDataValue: .constant(nil), currentNumber: self.$currentDataNumber,
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
                .padding(.bottom, -5)
                .frame(width: geometry.frame(in: .local).size.width, height: 240)
                .gesture(DragGesture()
                    .onChanged({ value in
                        self.move = value.translation.width
                        self.widthmove = value.startLocation
                        //print(self.dragLocation.x)
                        //print( self.move)
                        //print( self.widthmove)
                        //print("시간위치 \(value.startLocation)")
                        //print("트렌스 \(value.translation)")
                        //print("위치 \(value.location)")
                        //print("end \(value.predictedEndLocation)")
                        //print()
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
                Rectangle()
                    .frame(width: 800, height: 1)
                    .foregroundColor(Color.gray)
                    .opacity(0.1)
                    .shadow(color: Color.gray, radius: 12, x: 0, y: 6)
                    .blendMode(.multiply)
                    .padding(.top, 5)
                HStack {
                    Spacer()
                    Spacer()
                    Text("오늘")
                        .font(.system(size: 14))
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
                                .foregroundColor(.gray)
                                .font(.system(size: 14))
                            Spacer()
                        }
                    }
                    
                    Text("내일")
                        .font(.system(size: 14))
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
                                .font(.system(size: 14))
                            Spacer()
                        }
                    }
                    
                    Text("모래")
                        .font(.system(size: 14))
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
    @Binding public var move: CGFloat
    @Binding public var widthmove: CGPoint
    @Binding public var currentDataNumber: Double
    @Binding public var dragLocation:CGPoint
    @Binding public var colorline: Gradient
    
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var showLegend = false
    //@State public var dragLocation:CGPoint = .zero
    @State public var indicatorLocation:CGPoint = .zero
    @State public var closestPoint: CGPoint = .zero
    @State public var opacity:Double = 0
    @State public var hideHorizontalLines: Bool = false
    
    
    public init(data: [Double],
                title: String? = nil,
                legend: String? = nil,
                style: ChartStyle2 = Styles2.lineChartStyleOne2,
                valueSpecifier: String? = "%.1f",
                legendSpecifier: String? = "%.1f",
                move: Binding<CGFloat>,
                widthmove: Binding<CGPoint>,
                dragLocation: Binding<CGPoint>,
                currentDataNumber: Binding<Double>,
                colorline: Binding<Gradient>
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
        self._currentDataNumber = currentDataNumber
        self._dragLocation = dragLocation
        self._colorline = colorline
        
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
                              frame: .constant(CGRect(x: 0, y: 0, width: reader.frame(in: .local).width - 30, height: reader.frame(in: .local).height + 25)), currentNumber: self.$currentDataNumber ,
                              touchLocation: self.$indicatorLocation,
                              dragLocation: self.$dragLocation,
                              showIndicator: self.$hideHorizontalLines,
                              minDataValue: .constant(nil),
                              maxDataValue: .constant(nil),
                              showBackground: false,
                              gradient: self.style.gradientColor, colorline: self.$colorline
                        )
                        .offset(x: 30, y: 0)
                        .onAppear(){
                            self.showLegend = true
                        }
                        .onDisappear(){
                            self.showLegend = false
                        }
                        .onChange(of: dragLocation) { newLocation in
                            self.updateDragLocationY(geometry: reader.frame(in: .local))
                        }
                    }
                    .frame(width: geometry.frame(in: .local).size.width, height: 180)
                    .offset(x: 0, y: 40)
                }
                .frame(width: geometry.frame(in: .local).size.width, height: 240)
                
            }
        }
    }
    
    private func updateDragLocationY(geometry: CGRect) {
        let dataPoints = self.data.points
        let xStep = geometry.width / CGFloat(dataPoints.count - 1)
        let index = max(0, min(Int(self.dragLocation.x / xStep), dataPoints.count - 1))
        
        if index >= 0 && index < dataPoints.count {
            let yValue = dataPoints[index].1
            //print("뒤에 그래프 좌표:", currentDataNumber)
            self.dragLocation.y = CGFloat(1 - yValue + 240)
            currentDataNumber = Double(yValue-11)
            
        }
    }
    
}


