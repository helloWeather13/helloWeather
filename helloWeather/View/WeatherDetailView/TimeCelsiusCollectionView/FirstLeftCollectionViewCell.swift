//
//  FirstLeftCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import SnapKit
import SwiftUI
import SwiftUICharts

class FirstLeftCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FirstLeftCollectionViewCell.self)
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    var stackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    var celsiusLabel: UILabel = {
        let label = UILabel()
        label.text = "17"
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        label.textAlignment = .center
        return label
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "3시"
        label.font = UIFont(name: "Pretendard-Regular", size: 11)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints(data : WeatherDetailViewModel.HourlyWeather, isFirstCell: Bool) {
        
        // BarChart
        let barChartCellWrapper = BarChartCellWrapper (
            value: changeDataToHeight(data: data),
            index: 0,
            width: 60,
            numberOfDataPoints: 10,
            accentColor: isFirstCell ? .mygray : .mylightgray,
            touchLocation: .constant(-1.0)
        )
        
        // Constraints
        contentView.addSubview(stackView2)
        [celsiusLabel, barChartCellWrapper].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView, timeLabel].forEach {
            stackView2.addArrangedSubview($0)
        }
        
        stackView2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        celsiusLabel.snp.makeConstraints { make in
            make.height.equalTo(celsiusLabel.font.pointSize)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.height.equalTo(timeLabel.font.pointSize)
        }
        
        func changeDataToHeight(data: WeatherDetailViewModel.HourlyWeather) -> Double{
            var height: Double = 0.0
            if let tempC = Double(data.tempC.dropLast()) {
                switch tempC {
                case ..<0:
                    height = 0.1
                case 0..<10:
                    height = 0.2
                case 10..<15:
                    height = 0.3
                case 15..<20:
                    height = 0.4
                case 20..<25:
                    height = 0.5
                case 25..<30:
                    height = 0.6
                case 30..<35:
                    height = 0.7
                case 35..<40:
                    height = 0.8
                default:
                    height = 0.9
                }
            }
            return height
        }
        
    }
    
}


class BarChartCellWrapper: UIView {
    private var hostingController: UIHostingController<BarChartCell>?
    
    init(value: Double, index: Int = 0, width: Float, numberOfDataPoints: Int, accentColor: Color, touchLocation: Binding<CGFloat>) {
        super.init(frame: .zero)
        setupHostingController(value: value, index: index, width: width, numberOfDataPoints: numberOfDataPoints, accentColor: accentColor, touchLocation: touchLocation)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupHostingController(value: Double, index: Int, width: Float, numberOfDataPoints: Int, accentColor: Color, touchLocation: Binding<CGFloat>) {
        let barChartCell = BarChartCell(value: value, index: index, width: width, numberOfDataPoints: numberOfDataPoints, accentColor: accentColor, touchLocation: touchLocation)
        let hostingController = UIHostingController(rootView: barChartCell)
        hostingController.view.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        self.hostingController = hostingController
        addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: self.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

public struct BarChartCell: View {
    public var value: Double
    public var index: Int = 0
    public var width: Float
    public var numberOfDataPoints: Int
    public var cellWidth: Double {
        return Double(width) / (Double(numberOfDataPoints) * 1.5)
    }
    public var accentColor: Color
    
    @State public var scaleValue: Double = 0
    @Binding public var touchLocation: CGFloat
    
    public init(value: Double, index: Int = 0, width: Float, numberOfDataPoints: Int, accentColor: Color, touchLocation: Binding<CGFloat>) {
        self.value = value
        self.index = index
        self.width = width
        self.numberOfDataPoints = numberOfDataPoints
        self.accentColor = accentColor
        self._touchLocation = touchLocation
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(accentColor)
        }
        .frame(width: CGFloat(self.cellWidth))
        .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
        .onAppear {
            withAnimation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.02 : 0)) {
                self.scaleValue = self.value
            }
        }
    }
}
