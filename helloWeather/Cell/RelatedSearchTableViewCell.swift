//
//  RelatedSearchTableViewCell.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/14/24.
//

import UIKit

class RelatedSearchTableViewCell: UITableViewCell {

    static var identifier = "RelatedSearchTableViewCell"
    
    let wordsLabel = PaddingLabel()
    let line = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }

    func configureUI(text: String, keyword: String){
        self.addSubview(wordsLabel)
        self.addSubview(line)
        self.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        wordsLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsLabel.topInset = -20
        wordsLabel.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.07, green: 0.49, blue: 1.00, alpha: 1.00), range: (text as NSString).range(of: keyword))
        wordsLabel.attributedText = attributedString
        wordsLabel.font = UIFont(name: "Pretendard-Medium", size: 14)
        wordsLabel.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(4)
            make.height.equalTo(42)
        }
        line.snp.makeConstraints{
            $0.top.equalTo(wordsLabel.snp.bottom).inset(11)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview().offset(4)
        }
        line.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.02)
    }

}
