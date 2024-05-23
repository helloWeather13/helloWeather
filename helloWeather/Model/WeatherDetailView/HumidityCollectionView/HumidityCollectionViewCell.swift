//
//  HumidityCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit
import SnapKit
import SwiftUI
import SwiftUICharts

class HumidityCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: HumidityCollectionViewCell.self)
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    let stackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    let percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 12)
        label.textAlignment = .center
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
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
    
    func configureConstraints(data: WeatherDetailViewModel.HourlyWeather, isFirstCell: Bool) {
        
        let barChartCellWrapper = BarChartCellWrapper4 (
            value: changeDataToHeight(data: data),
            index: 0,
            width: 60,
            numberOfDataPoints: 10,
            accentColor: isFirstCell ? .myblue : .mylightblue,
            touchLocation: .constant(-1.0)
        )
        
        contentView.addSubview(stackView2)
        stackView.addArrangedSubview(percentLabel)
        stackView.addArrangedSubview(barChartCellWrapper)
        
        stackView2.addArrangedSubview(stackView)
        stackView2.addArrangedSubview(timeLabel)
        
        stackView2.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        percentLabel.snp.makeConstraints { make in
            make.height.equalTo(percentLabel.font.pointSize)
        }
        
        func changeDataToHeight(data: WeatherDetailViewModel.HourlyWeather) -> Double{
            var height: Double = 0.0
            if let tempC = Double(data.humidity.dropLast()) {
                switch tempC {
                case ..<10:
                    height = 0.0
                case 10..<20:
                    height = 0.2
                case 20..<30:
                    height = 0.3
                case 30..<40:
                    height = 0.4
                case 40..<50:
                    height = 0.5
                case 50..<60:
                    height = 0.6
                case 60..<70:
                    height = 0.7
                case 70..<80:
                    height = 0.8
                case 80..<90:
                    height = 0.9
                default:
                    height = 1.0
                }
            }
            return height
        }
        
        
        
    }
    
}


class BarChartCellWrapper4: UIView {
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


public struct BarChartCell4: View {
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
            RoundedRectangle(cornerRadius: 10)
                .fill(accentColor)
        }
        .frame(width: CGFloat(self.cellWidth))
        .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
        .onAppear {
            withAnimation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.02 : 0)) { // 애니메이션 적용
                self.scaleValue = self.value
            }
        }
    }
}
