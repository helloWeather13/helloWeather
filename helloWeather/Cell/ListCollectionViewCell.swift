import UIKit
import SnapKit

class ListCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "ListCellIdentifier"
    
    var capitalLabel: UILabel! // 도시 이름 레이블의 선언.
    var nowTemperatureLabel: UILabel! // 현재기온 레이블의 선언.
    var highTemperatureLabel: UILabel! // 최고온도 레이블의 선언
    var lowTemperatureLabel: UILabel! // 최저온도 레이블의 선언
    //    var switchButton: UISwitch! // 스위치 버튼의 선언.
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
        }
        
        // 현재기온 레이블의 생성 및 설정
        nowTemperatureLabel = UILabel()
        contentView.addSubview(nowTemperatureLabel)
        nowTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(capitalLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(20)
        }
        
        // 최고온도 레이블의 생성 및 설정
        highTemperatureLabel = UILabel()
        contentView.addSubview(highTemperatureLabel)
        highTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(nowTemperatureLabel.snp.top)
            make.leading.equalTo(nowTemperatureLabel.snp.trailing).offset(5)
            make.width.equalTo(20)
        }
        
        // 최저온도 레이블의 생성 및 설정
        lowTemperatureLabel = UILabel()
        contentView.addSubview(lowTemperatureLabel)
        lowTemperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(highTemperatureLabel.snp.top)
            make.leading.equalTo(highTemperatureLabel.snp.trailing).offset(5)
            make.trailing.equalToSuperview().offset(-10)
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
        
        //        // 스위치 버튼의 생성 및 설정 (스위치 미사용)
        //        switchButton = UISwitch()
        //        contentView.addSubview(switchButton)
        //        switchButton.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged) // 스위치의 valueChanged 이벤트에 스위치 토글 함수(하단 익스텐션에 있음) 연결
        //        switchButton.snp.makeConstraints { make in
        //            // Y축 설정
        //            make.centerY.equalToSuperview().offset(0)
        //            // X축에 대하여 우측 끝부터 얼만큼 떨어질지
        //            make.trailing.equalToSuperview().offset(-10)
        //        }
        
        // 배경색 변경 (밝은 회색)
        contentView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        // 셀 코너깎음 정도.
        contentView.layer.cornerRadius = 10
        // 셀 경계에 masksToBounds (코너깎음이랑 세트로 써야한대서 그냥 썼습니다)
        contentView.layer.masksToBounds = true
        // 스위치가 On 되었을 때의 색상 설정
        //        switchButton.onTintColor = UIColor.black
        
        // 테두리 두께 1로 설정하고 테두리 색상을 검정으로 설정. (안할거임)
        //        contentView.layer.borderWidth = 1
        //        contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init 미구현")
    }
}

// ListViewCell 클래스에 버튼 액션에 대한 함수 추가
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

