//
//  ListTableViewCell.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa


class ListTableViewCell: UITableViewCell {
    
    static var identifier = "ListTableViewCell"
    
    var cityLabel = UILabel()
    var conditionLabel = UILabel()
    var temperatureLabel = UILabel()
    var weatherImage = UIImageView()
    var minMaxTempLabel = UILabel()
    var alarmImageView = UIImageView()
    var deleteView = UIView()
    var viewContainer = UIView()
    var deleteButton = UIButton()
    var disposeBag = DisposeBag()
    var isAlarm = false
    
    //    var weatherAPIModel : WeatherAPIModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        self.viewContainer.snp.updateConstraints {
            $0.trailing.equalToSuperview().offset(0)
        }
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00).cgColor
        contentView.clipsToBounds = true
        
    }
    
    func configure(searchModel: SearchModel){
        WebServiceManager.shared.getForecastWeather(searchModel: searchModel, completion: { data in
            self.configureUI(weatherAPIModel: data, searchModel: searchModel)
        })
    }
    
    @objc func didSwipeCellLeft(){
        UIView.animate(withDuration: 0.3) {
            self.viewContainer.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-70)
            }
            self.deleteButton.isHidden = false
            self.viewContainer.superview?.layoutIfNeeded()
            self.deleteButton.superview?.layoutIfNeeded()
            self.deleteButton.isEnabled = true
        }
    }
    
    @objc func didSwipeCellRight(){
        UIView.animate(withDuration: 0.3) {
            self.viewContainer.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(0)
            }
            self.deleteButton.isHidden = true
            self.deleteButton.isEnabled = false
            self.viewContainer.superview?.layoutIfNeeded()
            self.deleteButton.superview?.layoutIfNeeded()
        }
    }
    
    var buttonTap: Observable<Void> {
        return deleteButton.rx.tap.asObservable()
    }
    func setupAlarmImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alarmImageViewTapped))
                alarmImageView.addGestureRecognizer(tapGesture)
                alarmImageView.isUserInteractionEnabled = true
    }
    
    @objc func alarmImageViewTapped() {
        if isAlarm {
            alarmImageView.image = .alarm0
            isAlarm = false
        } else {
            alarmImageView.image = .alarm1
            isAlarm = true
        }
    }
    func configureUI(weatherAPIModel : WeatherAPIModel, searchModel : SearchModel) {
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeCellLeft))
        swipeGestureLeft.direction = .left
        self.addGestureRecognizer(swipeGestureLeft)
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeCellRight))
        swipeGestureRight.direction = .right
        self.addGestureRecognizer(swipeGestureRight)
        setupAlarmImageView()
        contentView.addSubview(viewContainer)
        
        [cityLabel, conditionLabel,temperatureLabel,weatherImage,minMaxTempLabel,alarmImageView].forEach{
            viewContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .label
        }
        contentView.addSubview(deleteView)
        deleteView.addSubview(deleteButton)
        deleteButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        deleteButton.isHidden = true
        deleteView.backgroundColor = .red
        cityLabel.text = searchModel.city + ","
        cityLabel.font = .boldSystemFont(ofSize: 13)
        cityLabel.sizeToFit()
        conditionLabel.text = weatherAPIModel.current?.condition.text
        conditionLabel.font = .systemFont(ofSize: 13)
        conditionLabel.sizeToFit()
        temperatureLabel.text = String(Int(weatherAPIModel.current?.feelslikeC ?? 0)) + "°"
        temperatureLabel.font = .boldSystemFont(ofSize: 42)
        temperatureLabel.sizeToFit()
        weatherImage.image = UIImage(systemName: "cloud.sun.rain.fill")
        minMaxTempLabel.text = String(Int(weatherAPIModel.forecast.forecastday[0].day.maxtempC)) + "°" + " " + String(Int(weatherAPIModel.forecast.forecastday[0].day.mintempC)) + "°"
        minMaxTempLabel.textColor = .secondaryLabel
        minMaxTempLabel.font = .systemFont(ofSize: 12)
        minMaxTempLabel.sizeToFit()
        alarmImageView.image = .alarm0
        self.makeConstraints()
    }
    
    func makeConstraints(){
        viewContainer.snp.makeConstraints{
            $0.bottom.top.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        cityLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(viewContainer).offset(19)
        }
        conditionLabel.snp.makeConstraints{
            $0.leading.equalTo(cityLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(cityLabel)
        }
        temperatureLabel.snp.makeConstraints{
            //$0.top.equalTo(cityLabel.snp.bottom)
            $0.leading.equalTo(viewContainer).offset(20)
            $0.bottom.equalTo(viewContainer).inset(19)
        }
        alarmImageView.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.trailing.equalTo(viewContainer).offset(-20)
            $0.centerY.equalTo(viewContainer).inset(55)
            
        }
        weatherImage.snp.makeConstraints{
            $0.width.height.equalTo(52)
            $0.trailing.equalTo(alarmImageView.snp.leading).offset(-30)
            $0.top.equalTo(viewContainer).offset(16)
        }
        minMaxTempLabel.snp.makeConstraints{
            $0.top.equalTo(weatherImage.snp.bottom).offset(5)
            $0.centerX.equalTo(weatherImage)
        }
        deleteView.snp.makeConstraints{
            $0.top.bottom.equalTo(viewContainer)
            $0.leading.equalTo(viewContainer.snp.trailing)
            $0.trailing.equalTo(contentView)
        }
        deleteButton.snp.makeConstraints{
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }
    }
}

extension Reactive where Base: ListTableViewCell {
    var buttonTapped: ControlEvent<Void> { base.deleteButton.rx.tap }
}
