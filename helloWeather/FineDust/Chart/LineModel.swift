import SwiftUI

public struct Line2: View {
    @ObservedObject var data: ChartData
    @Binding var frame: CGRect
    @Binding var touchLocation: CGPoint
    @Binding var showIndicator: Bool
    @Binding var minDataValue: Double?
    @Binding var maxDataValue: Double?
    @Binding var currentNumber: Double
    @State private var showFull: Bool = false
    @State var showBackground: Bool = true
    var gradient: GradientColor = GradientColor(start: Color.red, end: Color.blue)
    var index: Int = 0
    let padding: CGFloat = 30
    var curvedLines: Bool = false
    
    var stepWidth: CGFloat {
        if data.points.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.points.count - 1)
    }
    
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data.onlyPoints()
        if minDataValue != nil && maxDataValue != nil {
            min = minDataValue!
            max = maxDataValue!
        } else if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        } else {
            return 0
        }
        if let min = min, let max = max, min != max {
            if min <= 0 {
                return (frame.size.height-padding) / CGFloat(max - min)
            } else {
                return (frame.size.height-padding) / CGFloat(max - min)
            }
        }
        return 0
    }
    
    var path: Path {
        let points = self.data.onlyPoints()
        return curvedLines ? Path.quadCurvedPathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight), globalOffset: minDataValue) : Path.linePathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    var closedPath: Path {
        let points = self.data.onlyPoints()
        return curvedLines ? Path.quadClosedCurvedPathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight), globalOffset: minDataValue) : Path.closedLinePathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    public var body: some View {
        ZStack {
            if self.showFull && self.showBackground {
                self.closedPath
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.green, .white]), startPoint: .bottom, endPoint: .top))
                    //.rotationEffect(.degrees(180), anchor: .center)
                    //.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    .transition(.opacity)
                //.animation(nil) // 애니메이션 중첩 방지
            }
            self.path
                .trim(from: 0, to: self.showFull ? 1 : 0)
                .stroke(LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .yellow, location: 0.0),
                        .init(color: .yellow, location: 0.1),
                        .init(color: .red, location: 0.2),
                        .init(color: .red, location: 0.3),
                        .init(color: .red, location: 0.4),
                        .init(color: .yellow, location: 0.5),
                        .init(color: .green, location: 0.6),
                        .init(color: .yellow, location: 0.7),
                        .init(color: .red, location: 0.8),
                        .init(color: .red, location: 0.9),
                        .init(color: .red, location: 1.0)
                    ]), startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 3, lineJoin: .round))
                //.rotationEffect(.degrees(180), anchor: .center)
                //.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            //.animation(nil) // 애니메이션 중첩 방지
                .onAppear {
                    withAnimation(Animation.easeOut(duration: 10.6).delay(Double(self.index) * 0.4)) {
                        self.showFull = true
                    }
                }
                .onDisappear {
                    withAnimation {
                        self.showFull = false
                    }
                }
            if true {
                IndicatorPoint(currentNumber: $currentNumber)
                    .position(self.getClosestPointOnPath(touchLocation: self.touchLocation))
                    //.rotationEffect(.degrees(180), anchor: .center)
                    //.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
    
    func getClosestPointOnPath(touchLocation: CGPoint) -> CGPoint {
        let closest = self.path.point(to: touchLocation.x)
        return closest
    }
}

public struct Line3: View {
    @ObservedObject var data: ChartData
    @Binding var frame: CGRect
    @Binding var currentNumber: Double
    @Binding var touchLocation: CGPoint
    @Binding var dragLocation: CGPoint
    @Binding var showIndicator: Bool
    @Binding var minDataValue: Double?
    @Binding var maxDataValue: Double?
    @State private var showFull: Bool = false
    @State var showBackground: Bool = true
    var gradient: GradientColor = GradientColor(start: Color.red, end: Color.blue)
    @Binding var colorline: Gradient
    @State var doubleTest = [Double]()
    var index: Int = 0
    let padding: CGFloat = 30
    var curvedLines: Bool = false
    
    var stepWidth: CGFloat {
        if data.points.count < 2 {
            return 0
        }
        return frame.size.width / CGFloat(data.points.count - 1)
    }
    
    var stepHeight: CGFloat {
        var min: Double?
        var max: Double?
        let points = self.data.onlyPoints()
        if minDataValue != nil && maxDataValue != nil {
            min = minDataValue!
            max = maxDataValue!
        } else if let minPoint = points.min(), let maxPoint = points.max(), minPoint != maxPoint {
            min = minPoint
            max = maxPoint
        } else {
            return 0
        }
        if let min = min, let max = max, min != max {
            if min <= 0 {
                return (frame.size.height-padding) / CGFloat(max - min)
            } else {
                return (frame.size.height-padding) / CGFloat(max - min)
            }
        }
        return 0
    }
    
    var path: Path {
        let points = self.data.onlyPoints()
        return curvedLines ? Path.quadCurvedPathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight), globalOffset: minDataValue) : Path.linePathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    var closedPath: Path {
        let points = self.data.onlyPoints()
        return curvedLines ? Path.quadClosedCurvedPathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight), globalOffset: minDataValue) : Path.closedLinePathWithPoints(points: points, step: CGPoint(x: stepWidth, y: stepHeight))
    }
    
    public var body: some View {
        ZStack {
            if self.showFull && self.showBackground {
            }
            self.path
                .trim(from: 0, to: self.showFull ? 1 : 0)
            // 간격조절하는 곳
                .stroke(LinearGradient(
                    gradient: colorline, startPoint: .leading, endPoint: .trailing), style: StrokeStyle(lineWidth: 3, lineJoin: .round, dash: [2, 2]))
                //.rotationEffect(.degrees(180), anchor: .center)
                //.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            //.animation(nil) // 애니메이션 중첩 방지
                .onAppear {
                    withAnimation(Animation.easeOut(duration: 10.6).delay(Double(self.index) * 0.4)) {
                        self.showFull = true
                    }
                    doubleTest = divideSecondValuesIntoTenSections(data.onlyPoints().map { ("", $0) })
                    print(doubleTest)
                }
                .onDisappear {
                    withAnimation {
                        self.showFull = false
                    }
                    
                }
                .onChange(of: dragLocation) {
                    self.showIndicator = true
                }
            if true {
                IndicatorPoint(currentNumber:  $currentNumber)
                    .position(self.getClosestPointOnPath(dragLocation: self.dragLocation))
                    //.rotationEffect(.degrees(180), anchor: .center)
                    //.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
    
    func getClosestPointOnPath(dragLocation: CGPoint) -> CGPoint {
        let closest = self.path.point(to: dragLocation.x)
        return closest
    }
    
    func performInitialSetup() {
        // Perform your custom setup actions here
        print("View has appeared, performing initial setup.")
        // Add any additional setup code here
    }
    
    func divideSecondValuesIntoTenSections(_ data: [(String, Double)]) -> [Double] {
        var sections: [Double] = []
        for (_, value) in data {
            let strideValues = stride(from: value, through: value + 9 * (value / 10), by: value / 10)
            sections.append(contentsOf: strideValues)
        }
        return sections
    }
    
}



