//
//  HumidityCollectionViewCell.swift
//  helloWeather
//
//  Created by 이유진 on 5/16/24.
//

import UIKit

class HumidityCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: HumidityCollectionViewCell.self)
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 78
        return stack
    }()
    
    let percentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
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
        stackView.addArrangedSubview(percentLabel)
        stackView.addArrangedSubview(timeLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        percentLabel.snp.makeConstraints { make in
            make.height.equalTo(percentLabel.font.pointSize)
        }
        
    }
    
}
