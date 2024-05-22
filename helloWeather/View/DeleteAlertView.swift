//
//  DeleteAlertView.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/17/24.
//

import UIKit
import SnapKit
import RxSwift

class DeleteAlertView: UIView {
    
    var disposeBag = DisposeBag()
    
    var titleLabel = UILabel()
    var cancelButton = UIButton()
    var deleteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    deinit{
        disposeBag = DisposeBag()
    }
    func configureView(){
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 21
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        self.layer.borderWidth = 1
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 16
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowPath = nil
        self.layer.masksToBounds = false
    }
    func configure(){
        configureView()
        titleLabel.text = "삭제 하실건가요?"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 16)
        cancelButton.setTitle("취소", for: .normal)
        cancelButton.setTitleColor(.label, for: .normal)
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.systemBackground, for: .normal)
        deleteButton.backgroundColor = .label
        [cancelButton,deleteButton].forEach{
            $0.layer.cornerRadius = 5
            $0.clipsToBounds = true
            $0.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
            $0.layer.borderWidth = 1
            
        }
        [titleLabel, cancelButton, deleteButton].forEach{
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        self.configureConstaints()
    }
    
    func configureConstaints(){
        titleLabel.snp.makeConstraints{
            $0.top.equalToSuperview().offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        cancelButton.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(24)
            $0.height.equalTo(48)
            $0.width.equalTo(119)
        }
        deleteButton.snp.makeConstraints{
            $0.height.equalTo(48)
            $0.width.equalTo(119)
            $0.centerY.equalTo(cancelButton)
            $0.trailing.equalToSuperview().offset(-24)
            
        }
        
    }

}
