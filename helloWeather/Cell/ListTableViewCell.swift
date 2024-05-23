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
import SkeletonView

class ListTableViewCell: UITableViewCell {
    
    static var identifier = "ListTableViewCell"
    weak var tempListViewController: UIViewController?
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
    var isBeingDragged = false
    //    var weatherAPIModel : WeatherAPIModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupAlarmImageView()
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
        contentView.layer.cornerRadius = 15
        contentView.clipsToBounds = true
        
        
        // 드래그가 진행중인 경우 셀의 테두리를 사라지게합니다.
        if isBeingDragged {
            contentView.layer.borderWidth = 0
        } else {
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00).cgColor
        }
    }
    // 터치이벤트가 아닌 드래그에 정상적으로 동작하게 하게 위해 필요한 메서드 3종세트
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        isBeingDragged = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        isBeingDragged = false
    }

    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        isBeingDragged = false
    }

    
    func configure(searchModel: SearchModel){
        self.makeConstraints()
        WebServiceManager.shared.getForecastWeather(searchModel: searchModel, completion: { data in
            self.configureUI(weatherAPIModel: data, searchModel: searchModel)
        })
    }
    
    @objc func didSwipeCellLeft(){
        UIView.animate(withDuration: 0.3) {
            self.viewContainer.snp.updateConstraints {
                $0.trailing.equalToSuperview().offset(-56)
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
    
    @objc func alarmImageViewTapped() {
        guard let viewController = tempListViewController else { return }
        
        if isAlarm {
            alarmImageView.image = .alarm0
            let alarmImageYellow = UIImageView()
            alarmImageYellow.image = .popupNotification1
            isAlarm = false
            viewController.showCustomAlert(image: alarmImageYellow.image!, message: "비소식 알림을 껐어요.")
        }
        else {
            alarmImageView.image = .alarm1
            let alarmImageYellow = UIImageView()
            alarmImageYellow.image = .popupNotification
            isAlarm = true
            viewController.showCustomAlert(image: alarmImageYellow.image!, message: "비소식 1시간 전에 알림을 울려요.")
        }
    }
    
    func configureUI(weatherAPIModel : WeatherAPIModel, searchModel : SearchModel) {
        let swipeGestureLeft = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeCellLeft))
        swipeGestureLeft.direction = .left
        self.addGestureRecognizer(swipeGestureLeft)
        
        let swipeGestureRight = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeCellRight))
        swipeGestureRight.direction = .right
        self.addGestureRecognizer(swipeGestureRight)

        viewContainer.layer.cornerRadius = 15
        viewContainer.clipsToBounds = true
        viewContainer.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
        deleteButton.setImage(UIImage(named: "trash"), for: .normal)
        deleteButton.isHidden = true
        deleteView.backgroundColor = .myred
        cityLabel.text = searchModel.city + ","
        cityLabel.font = .boldSystemFont(ofSize: 13)
        cityLabel.sizeToFit()
//        conditionLabel.text = weatherAPIModel.current?.condition.text
        conditionLabel.text = weatherAPIModel.current?.condition.change()
        conditionLabel.font = .systemFont(ofSize: 13)
        conditionLabel.sizeToFit()
        temperatureLabel.text = String(Int(weatherAPIModel.current?.feelslikeC ?? 0)) + "°"
        temperatureLabel.font = .boldSystemFont(ofSize: 42)
        temperatureLabel.sizeToFit()
        weatherImage.image = UIImage(named: "rainy")
        weatherImage.contentMode = .scaleAspectFit
        minMaxTempLabel.text = String(Int(weatherAPIModel.forecast.forecastday[0].day.maxtempC)) + "°" + "/ " + String(Int(weatherAPIModel.forecast.forecastday[0].day.mintempC)) + "°"
        minMaxTempLabel.textColor = .secondaryLabel
        minMaxTempLabel.font = .systemFont(ofSize: 12)
        minMaxTempLabel.sizeToFit()
        isAlarm = searchModel.notification
        alarmImageView.image = isAlarm ? .alarm1 : .alarm0
        setupAlarmImageView()
        setupWeatherImage()
        contentView.backgroundColor = .myred
    }
    // 흐린 -> 흐림
    // 맑음, 화창함 -> 맑음
    // 대체로 맑음 그대로 유지
    // 가벼운 소나기 -> 짧은 소나기
    // 곳곳에 가벼운 이슬비 -> 가벼운 비
    // 근처 곳곳에 비 -> 비
    // 보통 또는 심한 소나기 -> 소나기
    // 폭우 그대로 유지
    // 근처에 천둥 발생 -> 낙뢰
    // 천둥을 동반한 보통 또는 심한 비 -> 뇌우
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
    
    func setupAlarmImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(alarmImageViewTapped))
        alarmImageView.addGestureRecognizer(tapGesture)
        alarmImageView.isUserInteractionEnabled = true
    }
    func makeConstraints(){
        contentView.addSubview(viewContainer)
        [cityLabel, conditionLabel,temperatureLabel,weatherImage,minMaxTempLabel,alarmImageView].forEach{
            viewContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.tintColor = .label
            $0.layer.masksToBounds = true
        }
        
        contentView.addSubview(viewContainer)
        contentView.addSubview(deleteView)
        deleteView.addSubview(deleteButton)
        
        viewContainer.snp.makeConstraints{
            $0.bottom.top.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        cityLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(viewContainer).offset(16)
        }
        conditionLabel.snp.makeConstraints{
            $0.leading.equalTo(cityLabel.snp.trailing).offset(5)
            $0.centerY.equalTo(cityLabel)
        }
        temperatureLabel.snp.makeConstraints{
            $0.top.equalTo(cityLabel.snp.bottom).offset(8)
            $0.height.equalTo(42)
            $0.leading.equalTo(viewContainer).offset(16)
        }
        alarmImageView.snp.makeConstraints{
            $0.width.height.equalTo(16)
            $0.trailing.equalTo(viewContainer.snp.trailing).offset(-16)
            $0.top.equalTo(viewContainer.snp.top).offset(16)
        }
        weatherImage.snp.makeConstraints{
            $0.width.height.equalTo(36)
            $0.trailing.equalTo(viewContainer).offset(-16)
            $0.bottom.equalTo(viewContainer).offset(-16)
            
        }
        minMaxTempLabel.snp.makeConstraints{
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(8)
            $0.leading.equalTo(viewContainer).offset(16)
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
    var deleteViewTapped: Observable<Void> {
        let gestureRecognizer = UITapGestureRecognizer()
        base.deleteView.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer.rx.event.map { _ in () }
    }
}

extension Reactive where Base: ListTableViewCell {
    var buttonTapped: ControlEvent<Void> { base.deleteButton.rx.tap }
}

class CustomAlertView: UIView {
    private let imageView = UIImageView()
    private let messageLabel = UILabel()
    
    init(image: UIImage, message: String) {
        super.init(frame: .zero)
        
        // 이미지 뷰 설정
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        // 메시지 라벨 설정
        messageLabel.text = message
        messageLabel.textAlignment = .center
        addSubview(messageLabel)
        
        // 오토레이아웃 설정
        imageView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 40),
            
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            messageLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
