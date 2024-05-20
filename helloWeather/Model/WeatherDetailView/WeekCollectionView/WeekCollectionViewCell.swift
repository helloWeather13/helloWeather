//
//  bottomCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit

class WeekCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: WeekCollectionViewCell.self)
    
    let outerStackVeiw: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    let innerStackView1: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 3
        return stack
    }()
    let innerStackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10 //5
        return stack
    }()
    let innerStackView3: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10 //5
        return stack
    }()
    
    let weekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    let minCelsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    let maxCelsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    lazy var barChartCellWrapper = BarChartCellWrapper3(
        value: 0.9,
        index: 0,
        width: 60,
        numberOfDataPoints: 10,
        accentColor: .gray,
        touchLocation: .constant(-1.0)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        contentView.addSubview(outerStackVeiw)
        
        outerStackVeiw.addArrangedSubview(innerStackView2)
        outerStackVeiw.addArrangedSubview(innerStackView3)
        
        innerStackView1.addArrangedSubview(weekLabel)
        innerStackView1.addArrangedSubview(dateLabel)
        
        innerStackView2.addArrangedSubview(innerStackView1)
        innerStackView2.addArrangedSubview(weatherIcon)

        innerStackView3.addArrangedSubview(minCelsiusLabel)
        innerStackView3.addArrangedSubview(barChartCellWrapper)
        innerStackView3.addArrangedSubview(maxCelsiusLabel)
        
        outerStackVeiw.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        weekLabel.snp.makeConstraints { make in
            make.height.equalTo(weekLabel.font.pointSize)
        }
        dateLabel.snp.makeConstraints { make in
            make.height.equalTo(dateLabel.font.pointSize)
        }

        minCelsiusLabel.snp.makeConstraints { make in
            make.height.equalTo(minCelsiusLabel.font.pointSize)
        }
        maxCelsiusLabel.snp.makeConstraints { make in
            make.height.equalTo(maxCelsiusLabel.font.pointSize)
        }
        
        weatherIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
        }
    
    }
    
}

import SwiftUI
import UIKit
import SwiftUICharts
import SwiftUI
import UIKit

class BarChartCellWrapper3: UIView {
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

import SwiftUI

public struct BarChartCell3: View {
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
            self.scaleValue = self.value
        }
        .animation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.04 : 0))
    }
}
