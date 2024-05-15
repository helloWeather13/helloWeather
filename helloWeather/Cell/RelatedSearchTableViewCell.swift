//
//  RelatedSearchTableViewCell.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/14/24.
//

import UIKit

class RelatedSearchTableViewCell: UITableViewCell {

    static var identifier = "RelatedSearchTableViewCell"
    
    let wordsLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }

    func configureUI(text: String, keyword: String){
        self.addSubview(wordsLabel)
        wordsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: keyword))
        wordsLabel.attributedText = attributedString
        
        wordsLabel.snp.makeConstraints{make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(5)
            make.bottom.equalToSuperview().inset(5).priority(999)
            make.height.equalTo(42)
        }
    }

}
