//
//  GroupStruct.swift
//  helloWeather
//
//  Created by 김태담 on 5/18/24.
//

import Foundation
import SwiftUI
import SwiftUICharts

// 미세먼지 상태 얼굴 타입
enum Facetype: String {
    case happy = "좋음"
    case smile = "보통"
    case umm = "나쁨"
    case bad = "아주 나쁨"
    
    var image : Image{
        switch self {
        case .happy: return Image("air-great")
        case .smile: return Image("_air-good")
        case .umm: return Image("air-soso")
        case .bad: return Image("air-bad")
        }
    }
    
    var color : Color{
        switch self {
        case .happy: return Color.blue
        case .smile: return Color.green
        case .umm: return Color.orange
        case .bad: return Color.red
        }
    }
    
    var asValuetype: Valuetype {
        return Valuetype(rawValue: self.rawValue) ?? .umm
    }
}

// 미세먼지 컬러 타입
enum Valuetype: String {
    case happy = "아주 좋음"
    case smile = "좋음"
    case umm = "보통"
    case bad = "나쁨"
    
    var color : Color{
        switch self {
        case .happy: return .blue
        case .smile: return .green
        case .umm: return .orange
        case .bad: return .red
        }
    }
}

enum Valuetype2: String {
    case happy = "좋음"
    case smile = "보통"
    case umm = "나쁨"
    case bad = "아주나쁨"
    
    static func from(value: Double) -> Valuetype2 {
        switch value {
        case 0..<15:
            return .happy
        case 15..<35:
            return .smile
        case 35..<55:
            return .umm
        default:
            return .bad
        }
    }
    
    var color: Color {
        switch self {
        case .happy: return .blue
        case .smile: return .green
        case .umm: return .orange
        case .bad: return .red
        }
    }
}

// 라벨 상태를 나타내는 구조체
struct CustomChartView {
    let labels = ["매우 나쁨", "나쁨", "보통", "좋음"]
}

// 시간을 나타내는 구조체
struct TimeData {
    let time: Date
    let value: Double
}

//Path
extension Path {
    func point(to x: CGFloat) -> CGPoint {
        var prevPoint: CGPoint? = nil
        var closestPoint: CGPoint? = nil
        var minDistance: CGFloat = .infinity
        
        self.forEach { element in
            switch element {
            case .move(to: let p):
                prevPoint = p
            case .line(to: let p):
                guard let prevPoint = prevPoint else { return }
                let distance = abs(x - p.x)
                if distance < minDistance {
                    minDistance = distance
                    closestPoint = p
                }
                self.calculateClosestPoint(currentPoint: p, targetX: x, minDistance: &minDistance, closestPoint: &closestPoint)
                //prevPoint = p
            case .quadCurve(to: let p, control: _):
                guard let prevPoint = prevPoint else { return }
                let distance = abs(x - p.x)
                if distance < minDistance {
                    minDistance = distance
                    closestPoint = p
                }
                self.calculateClosestPoint(currentPoint: p, targetX: x, minDistance: &minDistance, closestPoint: &closestPoint)
                //prevPoint = p
            case .curve(to: let p, control1: _, control2: _):
                guard let prevPoint = prevPoint else { return }
                let distance = abs(x - p.x)
                if distance < minDistance {
                    minDistance = distance
                    closestPoint = p
                }
                self.calculateClosestPoint(currentPoint: p, targetX: x, minDistance: &minDistance, closestPoint: &closestPoint)
                //prevPoint = p
            case .closeSubpath:
                break
            }
        }
        return closestPoint ?? .zero
    }
    
    
    private func calculateClosestPoint(currentPoint: CGPoint, targetX: CGFloat, minDistance: inout CGFloat, closestPoint: inout CGPoint?) {
        let distance = abs(targetX - currentPoint.x)
        if distance < minDistance {
            minDistance = distance
            closestPoint = currentPoint
        }
    }
    static func quadCurvedPathWithPoints(points: [Double], step: CGPoint, globalOffset: Double? = nil) -> Path {
        var path = Path()
        if points.count < 2 {
            return path
        }
        let offset = globalOffset ?? points.min()!
        var p1 = CGPoint(x: 0, y: CGFloat(points[0] - offset) * step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y * CGFloat(points[pointIndex] - offset))
            let midPoint = CGPoint.midPointForPoints(p1: p1, p2: p2)
            path.addQuadCurve(to: midPoint, control: CGPoint.controlPointForPoints(p1: midPoint, p2: p1))
            path.addQuadCurve(to: p2, control: CGPoint.controlPointForPoints(p1: midPoint, p2: p2))
            p1 = p2
        }
        return path
    }
    
    static func linePathWithPoints(points: [Double], step: CGPoint) -> Path {
        var path = Path()
        if points.count < 2 {
            return path
        }
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0] - offset) * step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y * CGFloat(points[pointIndex] - offset))
            path.addLine(to: p2)
        }
        return path
    }
    
    static func quadClosedCurvedPathWithPoints(points: [Double], step: CGPoint, globalOffset: Double? = nil) -> Path {
        var path = Path()
        if points.count < 2 {
            return path
        }
        let offset = globalOffset ?? points.min()!
        var p1 = CGPoint(x: 0, y: CGFloat(points[0] - offset) * step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y * CGFloat(points[pointIndex] - offset))
            let midPoint = CGPoint.midPointForPoints(p1: p1, p2: p2)
            path.addQuadCurve(to: midPoint, control: CGPoint.controlPointForPoints(p1: midPoint, p2: p1))
            path.addQuadCurve(to: p2, control: CGPoint.controlPointForPoints(p1: midPoint, p2: p2))
            p1 = p2
        }
        path.addLine(to: CGPoint(x: p1.x, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        return path
    }
    
    static func closedLinePathWithPoints(points: [Double], step: CGPoint) -> Path {
        var path = Path()
        if points.count < 2 {
            return path
        }
        guard let offset = points.min() else { return path }
        let p1 = CGPoint(x: 0, y: CGFloat(points[0] - offset) * step.y)
        path.move(to: p1)
        for pointIndex in 1..<points.count {
            let p2 = CGPoint(x: step.x * CGFloat(pointIndex), y: step.y * CGFloat(points[pointIndex] - offset))
            path.addLine(to: p2)
        }
        path.addLine(to: CGPoint(x: CGFloat(points.count - 1) * step.x, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        return path
    }
}

extension CGPoint {
    static func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    static func controlPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = CGPoint.midPointForPoints(p1: p1, p2: p2)
        let diffY = abs(p2.y - controlPoint.y)
        
        if p1.y < p2.y {
            controlPoint.y += diffY
        } else if p1.y > p2.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}

// Point Color
struct IndicatorPoint: View {
    @Binding var currentNumber: Double
    @State private var chat1Color: Color = Color.gray
    
    private func updateChat1Color() {
        if currentNumber < 20 {
            chat1Color = Color.blue
        } else if currentNumber < 30 {
            chat1Color = Color.green
        } else if currentNumber < 40 {
            chat1Color = Color.yellow
        } else {
            chat1Color = Color.red
        }
    }
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.white)
            Circle()
                .stroke(chat1Color, style: StrokeStyle(lineWidth: 1))
        }
        .frame(width: 7, height: 7)
        .shadow(color: Color.white, radius: 6, x: 0, y: 6)
        .onChange(of: currentNumber) { _ in
            updateChat1Color()
        }
        .onAppear {
            updateChat1Color()
        }
    }
}

struct IndicatorPoint2: View {
    @Binding var currentNumber: Double
    @State private var chat1Color: Color = Color.gray
    
    private func updateChat1Color() {
        if currentNumber < 20 {
            chat1Color = Color.blue
        } else if currentNumber < 30 {
            chat1Color = Color.green
        } else if currentNumber < 40 {
            chat1Color = Color.yellow
        } else {
            chat1Color = Color.red
        }
    }
    
    var body: some View {
        ZStack{
            Circle()
                .fill(Color.white)
            Circle()
                .stroke(chat1Color, style: StrokeStyle(lineWidth: 1, dash: [1,1]))
        }
        .frame(width: 7, height: 7)
        .shadow(color: Color.white, radius: 6, x: 0, y: 6)
        .onChange(of: currentNumber) { _ in
            updateChat1Color()
        }
        .onAppear {
            updateChat1Color()
        }
    }
}

public struct Styles2 {
    public static let lineChartStyleOne = ChartStyle2(
        backgroundColor: Color.white,
        accentColor: Color.blue,
        secondGradientColor: Color.red,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let lineChartStyleOne2 = ChartStyle2(
        backgroundColor: Color.white,
        accentColor: Color.red,
        secondGradientColor: Color.green,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartStyleOrangeLight = ChartStyle2(
        backgroundColor: Color.white,
        accentColor: Color.orange,
        secondGradientColor: Color.orange,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartStyleOrangeDark = ChartStyle2(
        backgroundColor: Color.black,
        accentColor: Color.orange,
        secondGradientColor: Color.orange,
        textColor: Color.white,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartStyleNeonBlueLight = ChartStyle2(
        backgroundColor: Color.white,
        accentColor: Color.orange,
        secondGradientColor: Color.orange,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartStyleNeonBlueDark = ChartStyle2(
        backgroundColor: Color.black,
        accentColor: Color.orange,
        secondGradientColor: Color.orange,
        textColor: Color.white,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let barChartMidnightGreenDark = ChartStyle2(
        backgroundColor: Color("#36534D"), //3B5147, 313D34
        accentColor: Color("#FFD603"),
        secondGradientColor: Color("#FFCA04"),
        textColor: Color.white,
        legendTextColor: Color("#D2E5E1"),
        dropShadowColor: Color.gray)
    
    public static let barChartMidnightGreenLight = ChartStyle2(
        backgroundColor: Color.white,
        accentColor: Color("#84A094"), //84A094 , 698378
        secondGradientColor: Color("#50675D"),
        textColor: Color.black,
        legendTextColor:Color.gray,
        dropShadowColor: Color.gray)
    
    public static let pieChartStyleOne = ChartStyle2(
        backgroundColor: Color.white,
        accentColor: Colors.OrangeEnd,
        secondGradientColor: Colors.OrangeStart,
        textColor: Color.black,
        legendTextColor: Color.gray,
        dropShadowColor: Color.gray)
    
    public static let lineViewDarkMode = ChartStyle2(
        backgroundColor: Color.black,
        accentColor: Colors.OrangeStart,
        secondGradientColor: Colors.OrangeEnd,
        textColor: Color.white,
        legendTextColor: Color.white,
        dropShadowColor: Color.gray)
}

public struct MagnifierRect: View {
    @Binding var currentNumber: Double
    var valueSpecifier: String
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var chat1Color: Color = Color.gray

    private func updateChat1Color() {
        if currentNumber < 20 {
            chat1Color = Color.blue
        } else if currentNumber < 30 {
            chat1Color = Color.green
        } else if currentNumber < 40 {
            chat1Color = Color.yellow
        } else {
            chat1Color = Color.red
        }
    }

    public var body: some View {
        ZStack {
            //Text("\(self.currentNumber, specifier: valueSpecifier)")
                //.offset(x: 0, y: -110)
                //.foregroundColor(self.colorScheme == .dark ? Color.white : Color.black)
            Rectangle()
                .frame(width: 0.5, height: 220)
                .foregroundColor(chat1Color)
                .shadow(color: Color.gray, radius: 12, x: 0, y: 6)
                .blendMode(.multiply)
        }
        .offset(x: 0, y: -15)
        .onChange(of: currentNumber) { _ in
            //updateChat1Color()
        }
        .onAppear {
            //updateChat1Color()
        }
    }
}
