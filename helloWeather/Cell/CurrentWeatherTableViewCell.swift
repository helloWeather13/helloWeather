//
//  ListTableViewCell.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift

class CurrentWeatherTableViewCell: UITableViewCell {
    
    static var identifier = "CurrentWeatherTableViewCell"
    
    var cityLabel = UILabel()
    var conditionLabel = UILabel()
    var temperatureLabel = UILabel()
    var weatherImage = UIImageView()
    var minMaxTempLabel = UILabel()
    var alarmImageView = UIImageView()
    var viewContainer = UIView()
    var temperatureTextLabel = UILabel()
    var dustLabel = UILabel()
    var currentLocationImageView = UIImageView()
    
    
    //    var weatherAPIModel : WeatherAPIModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00).cgColor
        contentView.clipsToBounds = true
        
    }
    
    func configure(searchModel: SearchModel){
        WebServiceManager.shared.getForecastWeather(searchModel: searchModel, completion: { foreCastdata in
            WebServiceManager.shared.getHistoryWeather(searchModel: searchModel, completion: { historyData in
                self.configureUI(weatherAPIModel: foreCastdata, historyAPIModel: historyData, searchModel: searchModel)
            })
            
        })
    }
    
    func configureUI(weatherAPIModel : WeatherAPIModel, historyAPIModel :  WeatherAPIModel,searchModel : SearchModel) {
        
        contentView.addSubview(viewContainer)
        [currentLocationImageView,cityLabel, conditionLabel,temperatureLabel,weatherImage,minMaxTempLabel,alarmImageView, temperatureTextLabel, dustLabel].forEach{
            viewContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .label
        }
        
        cityLabel.text = searchModel.city + ","
        cityLabel.font = .boldSystemFont(ofSize: 13)
        cityLabel.sizeToFit()
        conditionLabel.text = weatherAPIModel.current?.condition.text
        conditionLabel.font = .systemFont(ofSize: 13)
        conditionLabel.sizeToFit()
        let todayTemp = weatherAPIModel.current?.feelslikeC ?? 0
        temperatureLabel.text = String(Int(weatherAPIModel.current?.feelslikeC ?? 0)) + "°"
        temperatureLabel.font = .boldSystemFont(ofSize: 42)
        temperatureLabel.sizeToFit()
        weatherImage.image = UIImage(systemName: "cloud.sun.rain.fill")
        minMaxTempLabel.text = String(Int(weatherAPIModel.forecast.forecastday[0].day.maxtempC)) + "°" + " " + String(Int(weatherAPIModel.forecast.forecastday[0].day.mintempC)) + "°"
        minMaxTempLabel.textColor = .secondaryLabel
        minMaxTempLabel.font = .systemFont(ofSize: 12)
        minMaxTempLabel.sizeToFit()
        alarmImageView.image = UIImage(systemName: "bell")
        currentLocationImageView.image = UIImage(systemName: "pin.fill")
        
        let yesterdayTemp = historyAPIModel.forecast.forecastday[0].day.avgtempC
        let difference = Int(todayTemp - yesterdayTemp)
        if difference < 0 {
            temperatureTextLabel.text = "어제보다 \(abs(difference))° 낮음"
        }else if difference > 0 {
            temperatureTextLabel.text = "어제보다 \(abs(difference))° 높음"
        }else{
            temperatureTextLabel.text = "어제랑 기온이 같음"
        }
        temperatureTextLabel.font = .systemFont(ofSize: 11)
        dustLabel.text = "미세 \(String((weatherAPIModel.current?.airQuality.fine)!)) , 초미세 \(String((weatherAPIModel.current?.airQuality.micro)!))"
        dustLabel.font = .systemFont(ofSize: 11)
        self.makeConstraints()
    }
    
    func makeConstraints(){
        viewContainer.snp.makeConstraints{
            $0.bottom.top.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        currentLocationImageView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(viewContainer).offset(17)
            $0.width.equalTo(14)
            $0.height.equalTo(16)
        }
        cityLabel.snp.makeConstraints{
            $0.leading.equalTo(currentLocationImageView.snp.trailing).offset(3)
            $0.top.equalTo(viewContainer).offset(16)
        }
        conditionLabel.snp.makeConstraints{
            $0.leading.equalTo(cityLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(cityLabel)
        }
        temperatureLabel.snp.makeConstraints{
            $0.centerY.equalTo(viewContainer)
            $0.leading.equalTo(viewContainer).offset(20)
//            $0.bottom.equalTo(viewContainer).inset(19)
        }
        temperatureTextLabel.snp.makeConstraints{
            $0.top.equalTo(temperatureLabel.snp.bottom).inset(4)
            $0.leading.equalTo(viewContainer).offset(20)
        }
        dustLabel.snp.makeConstraints{
            $0.top.equalTo(temperatureTextLabel.snp.bottom)
            $0.leading.equalTo(viewContainer).offset(20)
            $0.bottom.equalTo(viewContainer).inset(16)
        }
        alarmImageView.snp.makeConstraints{
            $0.width.height.equalTo(24)
            $0.trailing.equalTo(viewContainer).offset(-20)
            $0.centerY.equalTo(viewContainer).inset(55)
            
        }
        weatherImage.snp.makeConstraints{
            $0.width.height.equalTo(52)
            $0.trailing.equalTo(alarmImageView.snp.leading).offset(-30)
            $0.top.equalTo(viewContainer).offset(32)
        }
        minMaxTempLabel.snp.makeConstraints{
            $0.top.equalTo(weatherImage.snp.bottom).offset(5)
            $0.centerX.equalTo(weatherImage)
        }
    }
}
