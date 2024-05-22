//
//  WeatherDetailView.swift
//  helloWeather
//
//  Created by 이유진 on 5/14/24.
//

import UIKit
import SnapKit

class WeatherDetailView: UIView {
    
    var homeViewModel = HomeViewModel()
    
    // MARK: - Scroll
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    let contentView = UIView()
    
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
    
    // 일출일몰
    let sunView: UIView = {
        let view = UIView()
        return view
    }()
    let sunLabel: UILabel = {
        let label = UILabel()
        label.text = "일출일몰"
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()
    let sunGraph: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    let sunriseLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let sunsetLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    let sunriseInfoLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    // MARK: - 이부분이 데이터 넘기는 겁니다~~
    let weatherDetailViewModel = WeatherDetailViewModel(weatherManager: WebServiceManager.shared, userLocationPoint: (35.8563, 129.2134))
    
    // MARK: - CollectionView
    // 체감온도 stack
    let topScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        return scroll
    }()
    let topTomorrowImageView: UIImageView = {
        let image = UIImageView()
        image.image =  UIImage(named: "tomorrow")
        return image
    }()
    
    lazy var firstLeftCollectionView: TodayTimeCelsiusCollectionView = {
        let collectionView = TodayTimeCelsiusCollectionView(viewModel: weatherDetailViewModel)
        return collectionView
    }()
    lazy var firstRightCollectionView: TomorrowTimeCelsiusCollectionView = {
        let collectionView = TomorrowTimeCelsiusCollectionView(viewModel: weatherDetailViewModel, todayCollectionView: firstLeftCollectionView)
        return collectionView
    }()
    
    // 날씨 stack
    let bottomScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isScrollEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.alwaysBounceHorizontal = true
        return scroll
    }()
    let bottomTomorrowImageView: UIImageView = {
        let image = UIImageView()
        image.image =  UIImage(named: "bottomTomorrow")
        return image
    }()
    lazy var secondLeftCollectionView = TodayTimeWeatherCollectionView(viewModel: weatherDetailViewModel)
    lazy var secondRightCollectionView = TomorrowTimeWeatherCollectionView(viewModel: weatherDetailViewModel, todayCollectionView: secondLeftCollectionView)
    
    // 주간 날씨
    lazy var weekCollectionView = WeekCollectionView(viewModel: weatherDetailViewModel)
    // 습도
    lazy var humidityCollectionView = HumidityCollectionView(viewModel: weatherDetailViewModel)
    
    // MARK: - C/F ChangeToggle
    let customToggleView: CustomToggleView2
    let customToggleView2: CustomToggleView2
    let customToggleView3: CustomToggleView2
    
    // MARK: - override
    override init(frame: CGRect) {
        
        self.customToggleView = CustomToggleView2(viewModel: weatherDetailViewModel)
        self.customToggleView2 = CustomToggleView2(viewModel: weatherDetailViewModel)
        self.customToggleView3 = CustomToggleView2(viewModel: weatherDetailViewModel)
        
        super.init(frame: frame)
        
        self.backgroundColor = .white
        configureScrollView()
        configureConstraints()
        setupSunData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - func
    
    // ScrollView 설정
    private func configureScrollView() {
        self.addSubview(addressLabel)
        self.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [firstStackView, secondStackView, thirdStackView, fourthStackView, sunLabel, sunView, topScrollView, bottomScrollView, weekCollectionView, humidityCollectionView, customToggleView, customToggleView2, customToggleView3].forEach {
            contentView.addSubview($0)
        }
        
        //        topScrollView.addRightFadeEffect()
    }
    
    private func configureConstraints() {
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(68)
            make.centerX.equalTo(self)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(76)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
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
        
        
        // CollectionView
        topScrollView.addSubview(firstLeftCollectionView)
        topScrollView.addSubview(topTomorrowImageView)
        topScrollView.addSubview(firstRightCollectionView)
        
        bottomScrollView.addSubview(secondLeftCollectionView)
        bottomScrollView.addSubview(bottomTomorrowImageView)
        bottomScrollView.addSubview(secondRightCollectionView)
        
        // Constraints
        firstStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        topScrollView.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalTo(119)
        }
        
        topTomorrowImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(28)
            make.leading.equalTo(firstLeftCollectionView.snp.trailing).offset(24)
        }
        firstRightCollectionView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.height.equalTo(119)
            make.width.equalTo(393)
            make.leading.equalTo(topTomorrowImageView.snp.trailing).offset(24)
        }   
        
        secondStackView.snp.makeConstraints { make in
            make.top.equalTo(topScrollView.snp.bottom).offset(70)
            make.leading.equalToSuperview()
        }
        bottomScrollView.snp.makeConstraints { make in
            make.top.equalTo(secondStackView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(5)
            make.height.equalTo(152)
        }
        
        bottomTomorrowImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(29)
            make.leading.equalTo(secondLeftCollectionView.snp.trailing).offset(24)
        }
        secondRightCollectionView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(bottomTomorrowImageView.snp.trailing).offset(24)
            make.height.equalTo(152)
            make.width.equalTo(393)
        }
        
        thirdStackView.snp.makeConstraints { make in
            make.top.equalTo(bottomScrollView.snp.bottom).offset(70)
            make.leading.equalToSuperview()
        }
        weekCollectionView.snp.makeConstraints { make in
            make.top.equalTo(thirdStackView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(173)
        }
        
        fourthStackView.snp.makeConstraints { make in
            make.top.equalTo(weekCollectionView.snp.bottom).offset(70)
            make.leading.equalToSuperview()
        }
        humidityCollectionView.snp.makeConstraints { make in
            make.top.equalTo(fourthStackView.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.height.equalTo(119)
        }
        
        // SunView
        sunLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityCollectionView.snp.bottom).offset(70)
            make.leading.equalToSuperview()
        }
        sunView.snp.makeConstraints { make in
            make.top.equalTo(sunLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(78)
            make.height.equalTo(206)
            make.width.equalTo(393)
        }
        
        [sunGraph, sunriseLabel, sunsetLabel, sunriseInfoLabel].forEach {
            sunView.addSubview($0)
        }
    
        sunGraph.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(115)
            make.width.equalTo(270)
        }
        
        sunriseLabel.snp.makeConstraints { make in
            make.top.equalTo(sunGraph.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(45)
        }
        
        sunsetLabel.snp.makeConstraints { make in
            make.top.equalTo(sunGraph.snp.bottom).offset(5)
            make.trailing.equalToSuperview().inset(45)
        }
        
        sunriseInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(sunsetLabel.snp.bottom).offset(38)
            make.centerX.equalTo(sunView)
        }
        
        
        // Toggle
        
        customToggleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.width.equalTo(54)
            make.height.equalTo(30)
        }
        
        customToggleView2.snp.makeConstraints { make in
            make.top.equalTo(secondStackView.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalTo(54)
            make.height.equalTo(30)
        }
        
        customToggleView3.snp.makeConstraints { make in
            make.top.equalTo(thirdStackView.snp.top)
            make.trailing.equalToSuperview()
            make.width.equalTo(54)
            make.height.equalTo(30)
        }
    }
    
    private func setupSunData() {
        homeViewModel.estimatedOnCompleted = { [unowned self] in
            sunriseLabel.text = homeViewModel.sunriseTime
            sunsetLabel.text = homeViewModel.sunsetTime
            sunriseInfoLabel.text = homeViewModel.sunriseInfoString
            sunGraph.image = homeViewModel.sunImage
        }
    }
}


