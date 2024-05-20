//
//  FirstLeftCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import SnapKit
import Charts
import DGCharts

class FirstLeftCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FirstLeftCollectionViewCell.self)
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 78
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
    
    var barChartView: BarChartView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 36, height: 50)
        return view as! BarChartView
    }()
    
    var horizontal: [String]!
    var vertical: [Double]!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        configureConstraints()
//        setChart(dataPoints: [String], values: [Double])
//        
//        horizontal = [""]
//        vertical = ["celsiusLabel"]
//        setChart(dataPoints: horizontal, values: vertical)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        contentView.addSubview(stackView)
        [celsiusLabel, timeLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        celsiusLabel.snp.makeConstraints { make in
            make.height.equalTo(celsiusLabel.font.pointSize)
        }
        
    }
    
    private func setChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: values[i])
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "판매량")

        // 차트 컬러
        chartDataSet.colors = [.gray]

        // 데이터 삽입
        let chartData = BarChartData(dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
}
