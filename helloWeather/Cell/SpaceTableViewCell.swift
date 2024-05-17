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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }
    
    func configure(){
        self.addSubview(emptyView)
        emptyView.addSubview(lineView)
        lineView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
        
        emptyView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.height.equalTo(61)
            $0.leading.trailing.equalToSuperview()
        }
        lineView.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
            $0.height.equalTo(1)
        }
    }
}
