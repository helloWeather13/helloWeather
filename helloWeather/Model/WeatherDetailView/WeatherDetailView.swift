//
//  WeatherDetailView.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import SnapKit

class WeatherDetailView: UIView {
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        return scroll
    }()
    
    // MARK: - SubtitleLabels
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 강남구 역삼동"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // 체감온도 stack
    let firstStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
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
        stack.spacing = 20
        return stack
    }()
    let firstLeftCollectionView = TodayTimeCelsiusCollectionView()
    let firstRightCollectionView = TomorrowTimeCelsiusCollectionView()
    
    // 날씨 stack
    let secondOuterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 24
        return stack
    }()
    let secondLeftCollectionView = TodayTimeWeatherCollectionView()
    let secondRightCollectionView = TomorrowTimeWeatherCollectionView()
    
    // 주간 날씨
    let weekCollectionView = WeekCollectionView()
    
    let humidityCollectionView = HumidityCollectionView()
    
    // MARK: - override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        configureScrollView()
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureScrollView() {
        self.addSubview(addressLabel)
        self.addSubview(scrollView)
        
        [firstStackView, secondStackView, thirdStackView, fourthStackView, fifthStackView, firstOuterStackView, secondOuterStackView, weekCollectionView, humidityCollectionView].forEach {
            scrollView.addSubview($0)
        }
    }
    
    private func configureConstraints() {
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(68)
            make.centerX.equalTo(self)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(76)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        // Subtitles Stack
        firstStackView.addArrangedSubview(timeCelsiusLabel)
        firstStackView.addArrangedSubview(timeCelsiusIcon)
        
        secondStackView.addArrangedSubview(timeWeather)
        secondStackView.addArrangedSubview(timeWeatherIcon)
        
        thirdStackView.addArrangedSubview(weekWeatherLabel)
        thirdStackView.addArrangedSubview(weekWeatherIcon)
        
        fourthStackView.addArrangedSubview(humidityLabel)
        fourthStackView.addArrangedSubview(humidityIcon)
        
        fifthStackView.addArrangedSubview(sunLabel)
        fifthStackView.addArrangedSubview(sunIcon)
        
        // CollectionView
        firstOuterStackView.addArrangedSubview(firstLeftCollectionView)
        firstOuterStackView.addArrangedSubview(firstRightCollectionView)
        
        secondOuterStackView.addArrangedSubview(secondLeftCollectionView)
        secondOuterStackView.addArrangedSubview(secondRightCollectionView)
        
        // Constraints
        firstStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(20)
            make.leading.equalTo(scrollView).offset(20)
            make.trailing.equalTo(scrollView).inset(20)
        }
        firstOuterStackView.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(32)
            make.trailing.equalTo(scrollView).inset(32)
            make.height.equalTo(146)
            make.width.equalTo(361)
        }
        
        secondStackView.snp.makeConstraints { make in
            make.top.equalTo(firstOuterStackView.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(20)
            make.trailing.equalTo(scrollView).inset(20)
        }
        secondOuterStackView.snp.makeConstraints { make in
            make.top.equalTo(secondStackView.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(32)
            make.trailing.equalTo(scrollView).inset(32)
            make.height.equalTo(146)
            make.width.equalTo(361)
        }
        
        thirdStackView.snp.makeConstraints { make in
            make.top.equalTo(secondOuterStackView.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(20)
            make.trailing.equalTo(scrollView).inset(20)
        }
        weekCollectionView.snp.makeConstraints { make in
            make.top.equalTo(thirdStackView.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(32)
            make.trailing.equalTo(scrollView).inset(32)
            make.height.equalTo(173)
            make.width.equalTo(361)
        }
        
        fourthStackView.snp.makeConstraints { make in
            make.top.equalTo(weekCollectionView.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(20)
            make.trailing.equalTo(scrollView).inset(20)
        }
        humidityCollectionView.snp.makeConstraints { make in
            make.top.equalTo(fourthStackView.snp.bottom).offset(20)
            make.leading.equalTo(scrollView).offset(32)
            make.trailing.equalTo(scrollView).inset(32)
            make.height.equalTo(146)
            make.width.equalTo(361)
            make.bottom.equalTo(scrollView).offset(-20)
        }
    }
}

