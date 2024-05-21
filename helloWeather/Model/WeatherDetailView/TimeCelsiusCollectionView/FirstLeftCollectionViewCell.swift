//
//  FirstLeftCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import SnapKit
import SwiftUI

class FirstLeftCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FirstLeftCollectionViewCell.self)
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    lazy var stackView2: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 15
        return stack
    }()
    
    lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.text = "17"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "3시"
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    lazy var barChartCellWrapper = BarChartCellWrapper(
        //높이
        value: 0.7,
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

        
    }
    
}

import SwiftUI
import UIKit
import SwiftUICharts
import SwiftUI
import UIKit

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
            RoundedRectangle(cornerRadius: 10)
                .fill(accentColor)
        }
        .frame(width: CGFloat(self.cellWidth))
        .scaleEffect(CGSize(width: 1, height: self.scaleValue), anchor: .bottom)
        .onAppear {
            withAnimation(Animation.spring().delay(self.touchLocation < 0 ?  Double(self.index) * 0.04 : 0)) { // 애니메이션 적용
                self.scaleValue = self.value
            }
        }
    }
}
