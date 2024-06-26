//
//  ListTableViewCell.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift

protocol CurrentBookMarkDelegate{
    func bookMarkTouched(isMarked: Bool)
}

class CurrentWeatherTableViewCell: UITableViewCell {
    
    static var identifier = "CurrentWeatherTableViewCell"
    
    var cityLabel = UILabel()
    var conditionLabel = UILabel()
    var temperatureLabel = UILabel()
    var weatherImage = UIImageView()
    var minMaxTempLabel = UILabel()
    var bookmarkImageView = UIImageView()
    private var isMarked = false
    var viewContainer = UIView()
    var temperatureTextLabel = UILabel()
    var dustLabel = UILabel()
    var currentLocationImageView = UIImageView()
    weak var tempListViewController: UIViewController? 
    var currentLocationSearchModel : SearchModel?
    var delegate : CurrentBookMarkDelegate?
    //    var weatherAPIModel : WeatherAPIModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) // contentView 배경색을 파란색으로 설정
//        viewContainer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0) // viewContainer 배경색을 파란색으로 설정
        setupBookmarkImageView()
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 22, left: 0, bottom: 0, right: 0))
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00).cgColor
        
    }
    
    func configure(searchModel: SearchModel){
        var currentBookMark = loadCurrentBookMark()
        if currentBookMark.contains(where: {
            $0.fullAddress == searchModel.fullAddress
        }){
            isMarked = true
        }else{
            isMarked = false
        }
        currentLocationSearchModel = searchModel
        WebServiceManager.shared.getForecastWeather(searchModel: searchModel, completion: { foreCastdata in
            WebServiceManager.shared.getHistoryWeather(searchModel: searchModel, completion: { historyData in
                self.configureUI(weatherAPIModel: foreCastdata, historyAPIModel: historyData, searchModel: searchModel)
            })
            
        })
    }
    
    func configureUI(weatherAPIModel : WeatherAPIModel, historyAPIModel :  WeatherAPIModel,searchModel : SearchModel) {
        
        contentView.addSubview(viewContainer)
        [currentLocationImageView,cityLabel, conditionLabel,temperatureLabel,weatherImage,minMaxTempLabel,bookmarkImageView, temperatureTextLabel, dustLabel].forEach{
            viewContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .label
        }
        viewContainer.backgroundColor = .white
        cityLabel.text = searchModel.city + ","
        cityLabel.font = UIFont(name: "Pretendard-Bold", size: 13)
        cityLabel.sizeToFit()
        conditionLabel.text = weatherAPIModel.current?.condition.change()
        conditionLabel.font = UIFont(name: "Pretendard-Medium", size: 13)
        conditionLabel.sizeToFit()
        let todayTemp = weatherAPIModel.current?.feelslikeC ?? 0
        temperatureLabel.text = String(Int(weatherAPIModel.current?.feelslikeC ?? 0)) + "°"
        temperatureLabel.font = UIFont(name: "GmarketSansTTFBold", size: 42)
        temperatureLabel.sizeToFit()
//        weatherImage.image = UIImage(named: "cloud")
        minMaxTempLabel.text = String(Int(weatherAPIModel.forecast.forecastday[0].day.maxtempC)) + "°" + "/ " + String(Int(weatherAPIModel.forecast.forecastday[0].day.mintempC)) + "°"
        minMaxTempLabel.textColor = .secondaryLabel
        minMaxTempLabel.font = UIFont(name: "Pretendard-Medium", size: 12)
        minMaxTempLabel.sizeToFit()
        bookmarkImageView.image = isMarked ? .bookmarkS1 : .bookmarkS0
        dustLabel.font = UIFont(name: "Pretendard-Medium", size: 11)
        temperatureTextLabel.font = UIFont(name: "Pretendard-Medium", size: 11)
        currentLocationImageView.image = UIImage.navigation
        setupWeatherImage()
        
        let yesterdayTemp = historyAPIModel.forecast.forecastday[0].day.avgtempC
        let difference = Int(todayTemp - yesterdayTemp)
        if difference < 0 {
            temperatureTextLabel.text = "어제보다 \(abs(difference))° 낮음"
        }else if difference > 0 {
            temperatureTextLabel.text = "어제보다 \(abs(difference))° 높음"
        }else{
            temperatureTextLabel.text = "어제랑 기온이 같음"
        }
//        dustLabel.text = "미세 \(String((weatherAPIModel.current?.airQuality.fine)!))ㆍ초미세 \(String((weatherAPIModel.current?.airQuality.micro)!))"
        let mise = Double((weatherAPIModel.current?.airQuality.fine!)!)
        let chomise = Double((weatherAPIModel.current?.airQuality.micro)!)
        
        switch mise {
        case 0..<30:
            dustLabel.text = "미세 좋음"
        case 30..<80:
            dustLabel.text = "미세 보통"
        case 81..<150:
            dustLabel.text = "미세 나쁨"
        case 150...:
            dustLabel.text = "미세 매우 나쁨"
        default:
            dustLabel.text = "미세 실패"
        }
        
        switch chomise {
        case 0..<15:
            dustLabel.text = "\(dustLabel.text!) · 초미세 좋음"
        case 15..<35:
            dustLabel.text = "\(dustLabel.text!) · 초미세 보통"
        case 35..<75:
            dustLabel.text = "\(dustLabel.text!) · 초미세 나쁨"
        case 75...:
            dustLabel.text = "\(dustLabel.text!) · 초미세 매우 나쁨"
        default:
            dustLabel.text = "\(dustLabel.text!) · 초미세 실패"
        }
        dustLabel.font = .systemFont(ofSize: 11)
        self.makeConstraints()
    }
    
    
    func setupWeatherImage() {
        switch conditionLabel.text {
        case "맑음":
            weatherImage.image = UIImage(named: "clean-day")
        case "흐림":
            weatherImage.image = UIImage(named: "cloudStrong-day")
        case "대체로 맑음":
            weatherImage.image = UIImage(named: "cloud-day")
        case "짧은 소나기", "가벼운 비":
            weatherImage.image = UIImage(named: "rainWeak-day")
        case "비", "소나기":
            weatherImage.image = UIImage(named: "rainSrong-day")
        case "폭우": // 폭우 그림 바뀔 예정이라 따로 빼둠
            weatherImage.image = UIImage(named: "rainSrong-day")
        case "낙뢰":
            weatherImage.image = UIImage(named: "thunder-day")
        case "뇌우":
            weatherImage.image = UIImage(named: "storm-day")
        default:
            weatherImage.image = UIImage(named: "searchImage")
        }
    }
    
    func makeConstraints() {
        
//        guard let superview = self.superview else { return }
//
//        viewContainer.snp.makeConstraints {
//            $0.top.equalTo(superview.safeAreaLayoutGuide.snp.top).offset(20)
//            $0.bottom.equalTo(superview.safeAreaLayoutGuide.snp.bottom).offset(-20)
//            $0.leading.equalTo(superview.safeAreaLayoutGuide.snp.leading).offset(20)
//            $0.trailing.equalTo(superview.safeAreaLayoutGuide.snp.trailing).offset(-20)
//        }
        
        // viewContainer는 슈퍼뷰의 모든 모서리에 고정됩니다.
        viewContainer.snp.makeConstraints {
            $0.bottom.top.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        // currentLocationImageView는 슈퍼뷰의 왼쪽에서 20포인트 떨어져 있고,
        // viewContainer의 상단에서 17포인트 떨어져 있습니다.
        // 너비는 14, 높이는 16 포인트로 고정됩니다.
        currentLocationImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(viewContainer).offset(18.5)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
        }

        // cityLabel은 currentLocationImageView의 오른쪽에서 3포인트 떨어져 있고,
        // viewContainer의 상단에서 16포인트 떨어져 있습니다.
        cityLabel.snp.makeConstraints {
            $0.leading.equalTo(currentLocationImageView.snp.trailing).offset(3)
            $0.centerY.equalTo(currentLocationImageView)
        }

        // conditionLabel은 cityLabel의 오른쪽에서 5포인트 떨어져 있고,
        // cityLabel의 수직 중앙에 맞춰져 있습니다.
        conditionLabel.snp.makeConstraints {
            $0.leading.equalTo(cityLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(cityLabel)
        }

        // temperatureLabel은 viewContainer의 수직 중앙에 맞춰져 있고,
        // viewContainer의 왼쪽에서 20포인트 떨어져 있습니다.
        temperatureLabel.snp.makeConstraints {
            $0.leading.equalTo(currentLocationImageView)
            $0.top.equalTo(cityLabel.snp.bottom).offset(8)
            $0.height.equalTo(42)
            // $0.bottom.equalTo(viewContainer).inset(19) // 일단 뺌
        }

        // temperatureTextLabel은 temperatureLabel의 아래쪽에서 4포인트 안쪽으로 떨어져 있고,
        // viewContainer의 왼쪽에서 20포인트 떨어져 있습니다.
        temperatureTextLabel.snp.makeConstraints {
//            $0.top.equalTo(temperatureLabel.snp.bottom).inset(3)
            $0.leading.equalTo(currentLocationImageView)
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(8)
        }

        // dustLabel은 temperatureTextLabel의 아래쪽에 위치하며,
        // viewContainer의 왼쪽에서 20포인트 떨어져 있고,
        // viewContainer의 하단에서 16포인트 안쪽으로 떨어져 있습니다.
        dustLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureTextLabel.snp.bottom)
            $0.leading.equalTo(currentLocationImageView)
        }

        
        // alarmImageView는 너비와 높이가 24포인트로 고정되며,
        // viewContainer의 오른쪽에서 20포인트 안쪽으로 떨어져 있고,
        // viewContainer의 수직 중앙에서 55포인트 안쪽으로 떨어져 있습니다.
        bookmarkImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
            $0.trailing.equalTo(viewContainer).offset(-16)
            $0.top.equalTo(viewContainer.snp.top).offset(16)
        }

        
//        weatherImage.snp.makeConstraints{
//            $0.width.height.equalTo(52)
//            $0.trailing.equalTo(alarmImageView.snp.leading).offset(0)
//            $0.top.equalTo(viewContainer).offset(30)
        // weatherImage는 너비와 높이가 52포인트로 고정되며,
        // alarmImageView의 왼쪽에서 30포인트 떨어져 있고,
        // viewContainer의 상단에서 32포인트 떨어져 있습니다.
        weatherImage.snp.makeConstraints {
            //            $0.width.height.equalTo(52)
            //            $0.trailing.equalTo(alarmImageView.snp.leading).offset(-30)
            //            $0.top.equalTo(viewContainer).offset(32)
            $0.width.height.equalTo(36)
            $0.trailing.equalTo(viewContainer).offset(-16)
            $0.top.equalTo(bookmarkImageView.snp.bottom).offset(36)
        }

        // minMaxTempLabel은 weatherImage의 아래쪽에서 5포인트 떨어져 있고,
        // weatherImage의 수평 중앙에 맞춰져 있습니다.
        minMaxTempLabel.snp.makeConstraints {
            $0.top.equalTo(weatherImage.snp.bottom).offset(4)
            $0.centerX.equalTo(weatherImage)
            $0.bottom.equalTo(viewContainer).offset(-16)
        }
    }
    @objc func bookmarkImageViewTapped() {
        var currentBookMark = loadCurrentBookMark()
        guard let viewController = tempListViewController as? TempListViewController else { return }
        
        if !isMarked {
            bookmarkImageView.image = .bookmarkS1
            isMarked = true
            let bookMarkImage = UIImageView()
            bookMarkImage.image = .popupBookmark
            viewController.showCustomAlert(image: bookMarkImage.image!, message: "북마크 페이지에 추가했어요.")
            currentBookMark.insert(self.currentLocationSearchModel!, at: 0)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(currentBookMark){
                UserDefaults.standard.setValue(encoded, forKey: "bookMark")
            }
            
        } else {
            bookmarkImageView.image = .bookmarkS0
            isMarked = false
            let bookMarkImage = UIImageView()
            bookMarkImage.image = .popupBookmark1
            viewController.showCustomAlert(image: bookMarkImage.image!, message: "북마크 페이지에서 삭제했어요.")
            currentBookMark.removeAll(where: {
                $0.fullAddress == currentLocationSearchModel?.fullAddress
            })
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(currentBookMark){
                UserDefaults.standard.setValue(encoded, forKey: "bookMark")
            }
        }
        self.delegate?.bookMarkTouched(isMarked: isMarked)
    }
    func setupBookmarkImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bookmarkImageViewTapped))
        bookmarkImageView.addGestureRecognizer(tapGesture)
        bookmarkImageView.isUserInteractionEnabled = true
    }
    
    func loadCurrentBookMark() -> [SearchModel]{
        if let savedData = UserDefaults.standard.object(forKey: "bookMark") as? Data {
            let decoder = JSONDecoder()
            if let savedObject = try? decoder.decode([SearchModel].self, from: savedData) {
                return savedObject
            }
        }
        return []
    }
}

