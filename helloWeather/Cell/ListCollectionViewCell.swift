import UIKit
import SnapKit

class ListCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "ListCellIdentifier"
    
    var capitalLabel: UILabel! // 도시 이름 레이블의 선언.
    var nowTemperatureLabel: UILabel! // 현재기온 레이블의 선언. ex 25도
    var highTemperatureLabel: UILabel! // 최고온도 레이블의 선언 ex 28도
    var lowTemperatureLabel: UILabel! // 최저온도 레이블의 선언 ex 23도
    var conditionLabel: UILabel! // 현재 기상상태 레이블의 선언 ex 흐림
    var alarmButton: UIButton! // 알람 버튼의 선언
    var indexPath: IndexPath? // 셀의 indexPath를 저장하는 프로퍼티
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 도시 이름 레이블의 생성 및 설정
        capitalLabel = UILabel()
        contentView.addSubview(capitalLabel)
        capitalLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(50)
        }
        
        // 현재기온 레이블의 생성 및 설정
        nowTemperatureLabel = UILabel()
        contentView.addSubview(nowTemperatureLabel)
        nowTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(capitalLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(70)
        }
        
        // 최고온도 레이블의 생성 및 설정
        highTemperatureLabel = UILabel()
        contentView.addSubview(highTemperatureLabel)
        highTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(nowTemperatureLabel.snp.top)
            make.leading.equalTo(nowTemperatureLabel.snp.trailing).offset(20)
            make.width.equalTo(70)
        }
        
        // 최저온도 레이블의 생성 및 설정
        lowTemperatureLabel = UILabel()
        contentView.addSubview(lowTemperatureLabel)
        lowTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(highTemperatureLabel.snp.top)
            make.leading.equalTo(highTemperatureLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(70)
        }
        
        // 기상상태 레이블의 생성 및 설정
        conditionLabel = UILabel()
        contentView.addSubview(conditionLabel)
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(lowTemperatureLabel.snp.top)
            make.leading.equalTo(lowTemperatureLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(70)
        }
        
        alarmButton = UIButton(type: .custom)
        alarmButton.setTitle("B", for: .normal)
        alarmButton.setTitleColor(.black, for: .normal)
        alarmButton.backgroundColor = .red
        contentView.addSubview(alarmButton)
        alarmButton.addTarget(self, action: #selector(alarmButtonTapped(_:)), for: .touchUpInside) // 알람 버튼에 액션 추가
        alarmButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview() // Y축 중앙 정렬
            make.trailing.equalToSuperview().offset(-10) // X축에서 10만큼 떨어짐
            make.width.equalTo(24) // 너비 설정
            make.height.equalTo(24) // 높이 설정
        }
        
        contentView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(with searchModel: SearchModel, weatherModel: WeatherAPIModel) {
        capitalLabel.text = searchModel.keyWord
        // 현재 기온 설정
        if let currentTemperature = weatherModel.current?.tempC {
            nowTemperatureLabel.text = "\(currentTemperature)°C"
        }
        
        // 최고 온도 설정
        if let maxTemperature = weatherModel.forecast.forecastday.first?.day.maxtempC {
            highTemperatureLabel.text = "\(maxTemperature)°C"
        }
        
        // 최저 온도 설정
        if let minTemperature = weatherModel.forecast.forecastday.first?.day.mintempC {
            lowTemperatureLabel.text = "\(minTemperature)°C"
        }
        
        // 기상 상황 설정
        if let conditionText = weatherModel.current?.condition.text {
            conditionLabel.text = "\(conditionText)"
        }
        
        
        // 다른 레이블에 필요한 정보 설정
    }

}

// ListTableViewCell 클래스에 버튼 액션에 대한 함수 추가
extension ListCollectionViewCell {
    // 버튼 액션 처리를 위한 함수
    @objc func alarmButtonTapped(_ sender: UIButton) {
        // 현재 버튼의 상태 확인
        let currentState = sender.isSelected
        
        if currentState {
            // 버튼이 선택된 상태일 때의 동작
            print("\(capitalLabel.text ?? "")의 정보를 받지 않습니다.")
            alarmButton.backgroundColor = .red
        } else {
            // 버튼이 선택되지 않은 상태일 때의 동작
            print("\(capitalLabel.text ?? "")의 정보를 받습니다.")
            alarmButton.backgroundColor = .green
        }
        
        // 버튼의 상태 토글
        sender.isSelected = !currentState
    }
}

