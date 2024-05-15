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
        stack.spacing = 12
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
        stack.spacing = 54 //5
        return stack
    }()
    
    let weekLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        return label
    }()
    
    let weatherIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    let minCelsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        return label
    }()
    let maxCelsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
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
        [innerStackView1, innerStackView2].forEach {
            outerStackVeiw.addArrangedSubview($0)
        }
        
        [weekLabel, dateLabel].forEach {
            innerStackView1.addArrangedSubview($0)
        }
        [minCelsiusLabel, maxCelsiusLabel].forEach {
            innerStackView2.addArrangedSubview($0)
        }
        
        outerStackVeiw.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(32)
        }
    
    }
    
}
