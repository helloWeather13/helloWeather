//
//  leftCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import SnapKit
import SwiftUI
import SwiftUICharts

class SecondLeftCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: SecondLeftCollectionViewCell.self)
    
    var firstStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    var secondStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    var celsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    var weatherIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    var timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints(data: WeatherDetailViewModel.HourlyWeather, isFirstCell: Bool) {
        
        let barChartCellWrapper = BarChartCellWrapper2(
            //높이
            value: changeDataToHeight(data: data),
            index: 0,
            width: 60,
            numberOfDataPoints: 10,
            accentColor: isFirstCell ? .mygray : .mylightgray,
            touchLocation: .constant(-1.0)
        )
        
        
        [celsiusLabel, barChartCellWrapper, weatherIcon].forEach {
            firstStackView.addArrangedSubview($0)
        }
        [firstStackView, timeLabel].forEach {
            secondStackView.addArrangedSubview($0)
        }
        contentView.addSubview(secondStackView)
        
        secondStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        celsiusLabel.snp.makeConstraints { make in
            make.height.equalTo(celsiusLabel.font.pointSize)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
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


class BarChartCellWrapper2: UIView {
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

public struct BarChartCell2: View {
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
        .scaleEffect(CGSize(width: 15, height: self.scaleValue), anchor: .bottom)
        .onAppear {
            withAnimation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.02 : 0)) {
                self.scaleValue = self.value
            }
        }
    }
}
