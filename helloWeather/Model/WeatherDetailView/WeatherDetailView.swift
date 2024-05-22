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
    
    // 일출일몰뷰
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
    lazy var firstDayAfterTomorrowCollectionview: DATomorrowTimeCelsiusCollectionview = {
        let collectionView = DATomorrowTimeCelsiusCollectionview(viewModel: weatherDetailViewModel, todayCollectionView: firstLeftCollectionView,  tomorrowCollectionView: firstRightCollectionView)
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
    
    // MARK: - Toggle Button
    
    let changeButton1: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 8
        return view
    }()
    
    let fLabel: UILabel = {
        let label = UILabel()
        label.text = "°F"
        label.textAlignment = .center
        label.textColor = .mygray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let cLabel: UILabel = {
        let label = UILabel()
        label.text = "°C"
        label.textAlignment = .center
        label.textColor = .mygray
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    let toggleKnob: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    var isToggleOn = false
    
    // MARK: - override
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        configureScrollView()
        configureConstraints()
        setupSunData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ToggleButton 설정
    private func configureCustomToggleButton() {
        
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleButtonTapped))
            changeButton1.addGestureRecognizer(tapGesture)
            
        changeButton1.snp.makeConstraints { make in
                make.width.equalTo(100)
                make.height.equalTo(30)
                make.center.equalTo(self)  // You can adjust this position
            }
            
            fLabel.snp.makeConstraints { make in
                make.leading.top.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
            }
            
            cLabel.snp.makeConstraints { make in
                make.trailing.top.bottom.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.5)
            }
            
            toggleKnob.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(2)
                make.width.equalTo(changeButton1.snp.height).offset(-4)
                make.leading.equalToSuperview().offset(2)
            }
        }
        
        @objc private func toggleButtonTapped() {
            isToggleOn.toggle()
            
            UIView.animate(withDuration: 0.3) {
                if self.isToggleOn {
                    self.toggleKnob.snp.remakeConstraints { make in
                        make.top.bottom.equalToSuperview().inset(2)
                        make.trailing.equalToSuperview().inset(2)
                    }
                    self.changeButton1.backgroundColor = .blue
                } else {
                    self.toggleKnob.snp.remakeConstraints { make in
                        make.top.bottom.equalToSuperview().inset(2)
                        make.width.equalTo(self.changeButton1.snp.height).offset(0)
                        make.leading.equalToSuperview().offset(2)
                    }
                    self.changeButton1.backgroundColor = .gray
                }
                self.layoutIfNeeded()
            }
        }
    
    
    
    
    // ScrollView 설정
    private func configureScrollView() {
        self.addSubview(addressLabel)
        self.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [firstStackView, secondStackView, thirdStackView, fourthStackView, sunView, topScrollView, bottomScrollView, weekCollectionView, humidityCollectionView, changeButton1].forEach {
            contentView.addSubview($0)
        }
        
        //        topScrollView.addRightFadeEffect()
    }
    
    private func configureConstraints() {
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(68)
            make.centerX.equalTo(self)
        }
        [fLabel, cLabel, toggleKnob].forEach {
            changeButton1.addSubview($0)
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
        topScrollView.addSubview(firstDayAfterTomorrowCollectionview)
        
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
//        firstDayAfterTomorrowCollectionview.snp.makeConstraints { make in
//            make.top.bottom.equalToSuperview()
//            make.height.equalTo(119)
//            make.width.equalTo(393)
//            make.leading.equalTo(firstRightCollectionView.snp.trailing).offset(24)
//        }
        
        
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
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // Buttons Constraints
        changeButton1.snp.makeConstraints { make in
            make.top.equalTo(firstStackView.snp.top)
            make.leading.equalTo(firstStackView.snp.trailing).offset(158)
            make.width.equalTo(54)
            make.height.equalTo(30)
        }
        
        // 일출일몰 레이아웃
//        sunView.snp.makeConstraints { make in
//            make.top.equalTo(humidityCollectionView.snp.bottom).offset(30)
//            make.leading.equalTo(scrollView)
//            make.trailing.equalTo(scrollView)
//            make.bottom.equalTo(scrollView).inset(78)
//            make.height.equalTo(252)
//            make.width.equalTo(393)
//        }
//        
//        sunView.addSubview(sunLabel)
//        sunLabel.snp.makeConstraints { make in
//            make.top.equalTo(sunView).offset(4)
//            make.leading.equalTo(sunView).offset(20)
//        }
//        
//        sunView.addSubview(sunGraph)
//        sunGraph.snp.makeConstraints { make in
//            make.top.equalTo(sunLabel.snp.bottom).offset(30)
//            make.centerX.equalTo(sunView)
//            make.height.equalTo(154)
//            make.width.equalTo(300)
//        }
//        
//        sunView.addSubview(sunriseLabel)
//        sunriseLabel.snp.makeConstraints { make in
//            make.top.equalTo(sunGraph.snp.bottom)
//            make.leading.equalTo(sunView).offset(45)
//        }
//        
//        sunView.addSubview(sunsetLabel)
//        sunsetLabel.snp.makeConstraints { make in
//            make.top.equalTo(sunGraph.snp.bottom)
//            make.trailing.equalTo(sunView).offset(-45)
//        }
//        
//        sunView.addSubview(sunriseInfoLabel)
//        sunriseInfoLabel.snp.makeConstraints { make in
//            make.top.equalTo(sunsetLabel.snp.bottom).offset(38)
//            make.centerX.equalTo(sunView)
//        }
    }
    
    func setupSunData() {
        homeViewModel.estimatedOnCompleted = { [unowned self] in
            sunriseLabel.text = homeViewModel.sunriseTime
            sunsetLabel.text = homeViewModel.sunsetTime
            sunriseInfoLabel.text = homeViewModel.sunriseInfoString
            sunGraph.image = homeViewModel.sunImage
        }
    }
}


