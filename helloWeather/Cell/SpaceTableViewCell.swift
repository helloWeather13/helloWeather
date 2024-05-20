//
//  SpaceTableViewCell.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/16/24.
//

import UIKit
import SnapKit

class SpaceTableViewCell: UITableViewCell {

    static var identifier = "SpaceTableViewCell"
    var emptyView = UIView()
    var lineView = UIView()
    var alarmDescriptionLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }
    
    func configure() {
        self.addSubview(emptyView)
        emptyView.addSubview(lineView)
        emptyView.addSubview(alarmDescriptionLabel)
        
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        emptyView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(61)
            $0.leading.trailing.equalToSuperview()
        }
        lineView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.bottom.equalToSuperview().offset(45).priority(999)
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(1)
        }
        alarmDescriptionLabel.snp.makeConstraints {
            $0.height.equalTo(13)
            $0.width.equalTo(150)
            $0.top.equalTo(lineView.snp.bottom).offset(22)
            $0.centerX.equalToSuperview()
        }
    }

    // 추가된 메서드
    func configure(with viewModel: SpaceCellViewModel) {
        alarmDescriptionLabel.text = viewModel.alarmText
        alarmDescriptionLabel.textColor = viewModel.alarmTextColor
        alarmDescriptionLabel.font = viewModel.alarmTextFont
        alarmDescriptionLabel.textAlignment = viewModel.alarmTextAlignment
    }
}

