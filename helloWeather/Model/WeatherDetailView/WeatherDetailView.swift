//
//  WeatherDetailView.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import SnapKit

class WeatherDetailView: UIView {
    
    // MARK: - SubtitleLabels
    
    // 체감온도 stack
    let firstStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    let timeCelsiusLabel: UILabel = {
        let label = UILabel()
        label.text = "시간대별 체감온도"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    let timeCelsiusIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // 날씨 stack
    let secondStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    let timeWeather: UILabel = {
        let label = UILabel()
        label.text = "시간대별 날씨"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    let timeWeatherIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // 주간날씨 stack
    let thirdStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    let weekWeatherLabel: UILabel = {
        let label = UILabel()
        label.text = "주간 날씨 예보"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    let weekWeatherIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // 습도 stack
    let fourthStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    let humidityLabel: UILabel = {
        let label = UILabel()
        label.text = "시간대별 습도"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    let humidityIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // 일출일몰 stack
    let fifthStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 4
        return stack
    }()
    let sunLabel: UILabel = {
        let label = UILabel()
        label.text = "일출일몰"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    let sunIcon: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    
    // MARK: - CollectionView
    
    // 체감온도 stack
    let firstOuterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()
    let firstLeftCollectionView = TodayTimeCelsiusCollectionView()
    let firstRightCollectionView = TomorrowTimeCelsiusCollectionView()
    let topLineImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // 날씨 stack
    let secondOuterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()
    let secondLeftCollectionView = TodayTimeWeatherCollectionView()
    let secondRightCollectionView = TomorrowTimeWeatherCollectionView()
    let bottomLineImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // 주간 날씨
    let weekCollectionView = WeekCollectionView()
    
    let humidityCollectionView = HumidityCollectionView()
    
    // MARK: - override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureConstraints() {
        
        // MARK: - addSubView,addArrangedSubView
        // Subtitles Stack
        [firstStackView, secondStackView, thirdStackView, fourthStackView, fifthStackView].forEach {
            self.addSubview($0)
        }
        
        [timeCelsiusLabel, timeCelsiusIcon].forEach {
            firstStackView.addArrangedSubview($0)
        }
        [timeWeather, timeWeatherIcon].forEach {
            secondStackView.addArrangedSubview($0)
        }
        [weekWeatherLabel, weekWeatherIcon].forEach {
            thirdStackView.addArrangedSubview($0)
        }
        [humidityLabel, humidityIcon].forEach {
            fourthStackView.addArrangedSubview($0)
        }
        [sunLabel, sunIcon].forEach {
            fifthStackView.addArrangedSubview($0)
        }
        
        // CollectionView
        [firstOuterStackView, secondOuterStackView, weekCollectionView, humidityCollectionView].forEach {
            self.addSubview($0)
        }
        
        [firstLeftCollectionView, firstRightCollectionView, topLineImageView].forEach {
            firstOuterStackView.addArrangedSubview($0)
        }
        [secondLeftCollectionView, secondRightCollectionView, bottomLineImageView].forEach {
            secondOuterStackView.addArrangedSubview($0)
        }
        
        // MARK: - Constraints
        // 시간대별 체감온도
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(36)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(208)
        }
        firstOuterStackView.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(32)
        }
        
        // 시간대별 날씨
        secondStackView.snp.makeConstraints { make in
            make.top.equalTo(firstOuterStackView.snp.bottom).offset(102.5)
            make.leading.equalToSuperview().offset(20)
        }
        secondOuterStackView.snp.makeConstraints { make in
            make.top.equalTo(secondStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(32)
        }
        
        // 주간날씨 예보
        thirdStackView.snp.makeConstraints { make in
            make.top.equalTo(secondOuterStackView.snp.bottom).offset(102.5)
            make.leading.equalToSuperview().offset(20)
        }
        weekCollectionView.snp.makeConstraints { make in
            make.top.equalTo(thirdStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(32)
        }
        
        // 시간대별 습도
        fourthStackView.snp.makeConstraints { make in
            make.top.equalTo(weekCollectionView.snp.bottom).offset(102.5)
            make.leading.equalToSuperview().offset(20)
        }
        humidityCollectionView.snp.makeConstraints { make in
            make.top.equalTo(thirdStackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(32)
        }
        
    }
 
}
