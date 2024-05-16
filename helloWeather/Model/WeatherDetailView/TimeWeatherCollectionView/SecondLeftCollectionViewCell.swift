//
//  leftCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit

class SecondLeftCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: SecondLeftCollectionViewCell.self)
    
    lazy var firstStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 65
        return stack
    }()
    
    lazy var secondStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 22
        return stack
    }()
    
    lazy var celsiusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    lazy var weatherIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
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
        
        [celsiusLabel, weatherIcon].forEach {
            firstStackView.addArrangedSubview($0)
        }
        [firstStackView, timeLabel].forEach {
            secondStackView.addArrangedSubview($0)
        }
        contentView.addSubview(secondStackView)
        
        secondStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
}
