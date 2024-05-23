//
//  RecentSearchTableViewCell.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/15/24.
//

import UIKit
import SnapKit

class RecentSearchTableViewCell: UITableViewCell {
    
    static var identifier = "RecentSearchTableViewCell"
    
    let titleLabel = UILabel()
    let timeImageview = UIImageView()
    let goImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }
    func configureUI(text : String){
        
        titleLabel.text = text
        titleLabel.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        titleLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        [timeImageview, titleLabel,goImageView].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        timeImageview.image = UIImage(named: "history")
        timeImageview.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
        timeImageview.contentMode = .center
        timeImageview.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha:0.09)
        timeImageview.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.02)
        goImageView.image = UIImage(named: "link")
        goImageView.backgroundColor = .clear
        goImageView.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.06)
        goImageView.contentMode = .center
        timeImageview.snp.makeConstraints{
            $0.leading.equalToSuperview()
            $0.width.equalTo(54)
            $0.height.equalTo(54)
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-16)
        }
        titleLabel.snp.makeConstraints{
            $0.leading.equalTo(timeImageview.snp.trailing).offset(8)
            $0.top.bottom.equalTo(timeImageview)
        }
        goImageView.snp.makeConstraints{
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalTo(titleLabel.snp.trailing).priority(999)
            $0.width.equalTo(24)
            $0.height.equalTo(24)
        }
        timeImageview.layer.cornerRadius = 26
        timeImageview.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha:0.06).cgColor
        timeImageview.layer.borderWidth = 0.6
        timeImageview.clipsToBounds = true
        
    }
    
}
