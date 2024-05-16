//
//  FirstLeftCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import SnapKit

class FirstLeftCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: FirstLeftCollectionViewCell.self)
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 100
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
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
    
}
