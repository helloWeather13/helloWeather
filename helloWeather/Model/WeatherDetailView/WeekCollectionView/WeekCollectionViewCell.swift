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
        stack.spacing = 16
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
        stack.spacing = 12 //5
        return stack
    }()
    let innerStackView3: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 64 //5
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
        
        weatherIcon.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.width.equalTo(24)
        }

        minCelsiusLabel.snp.makeConstraints { make in
            make.height.equalTo(minCelsiusLabel.font.pointSize)
        }
        maxCelsiusLabel.snp.makeConstraints { make in
            make.height.equalTo(maxCelsiusLabel.font.pointSize)
        }
    
    }
    
}
