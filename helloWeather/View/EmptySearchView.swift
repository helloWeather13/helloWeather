//
//  EmptySearchView.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/18/24.
//

import UIKit
import SnapKit
class EmptySearchView: UIView {

    var emptyImageView = UIImageView()
    var emptyTextLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(){
        self.backgroundColor = .systemBackground
        [emptyImageView,emptyTextLabel].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        }
        emptyImageView.image = UIImage(systemName: "magnifyingglass")
        emptyTextLabel.text = "검색한 내역이 없어요"
        emptyTextLabel.font = .boldSystemFont(ofSize: 15)
        emptyTextLabel.textAlignment = .center
        emptyTextLabel.sizeToFit()
        emptyTextLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        emptyImageView.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(52)
            $0.top.equalToSuperview().offset(186)
        }
        emptyTextLabel.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emptyImageView.snp.bottom).offset(16)
        }
    }
}
