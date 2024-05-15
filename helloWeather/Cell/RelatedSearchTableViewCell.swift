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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }

    func configureUI(text: String, keyword: String){
        self.addSubview(wordsLabel)
        wordsLabel.translatesAutoresizingMaskIntoConstraints = false
        wordsLabel.topInset = -20
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor(red: 0.07, green: 0.49, blue: 1.00, alpha: 1.00), range: (text as NSString).range(of: keyword))
        wordsLabel.attributedText = attributedString
        wordsLabel.font = .systemFont(ofSize: 14)
        wordsLabel.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().offset(4)
            make.height.equalTo(42)
        }
    }

}
