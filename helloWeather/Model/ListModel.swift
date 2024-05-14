//
//  ListModel.swift
//  helloWeather
//
//  Created by Seungseop Lee on 5/13/24.
//

import UIKit
import Alamofire
import SnapKit
import Foundation

// 셀 시작 (따로 빼도 될텐데 어디에 뺄지, MVVM에서는 Cell 파일 따로 만들어도 되는지 몰라서 일단 같이 넣었습니다)
class ListViewCell: UICollectionViewCell {
    
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
extension ListViewCell {
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

// 스위치 토글 액션 (SwitchButtonTapped) 별도 확장 (스위치 미사용)
//extension ListViewCell {
//    // 스위치 토글 액션 처리를 위한 함수
//    @objc func switchToggled(_ sender: UISwitch) {
//        if let indexPath = self.indexPath,
//           let collectionView = self.superview as? UICollectionView {
//            let item = (collectionView.delegate as? UICollectionViewDataSource)?.collectionView(collectionView, cellForItemAt: indexPath) as? ListViewCell
//            if sender.isOn {
//                // 임시로 프린트 찍어보기
//                print("\(item?.titleLabel.text ?? "")의 \(item?.descriptionLabel.text ?? "") 정보를 받습니다.")
//            } else {
//                print("\(item?.titleLabel.text ?? "")의 \(item?.descriptionLabel.text ?? "") 정보를 받지않습니다.")
//            }
//        }
//    }
//}

// 여까지가 cell 끝. 아픙로는 model관련

// View 정의
class ListView: UICollectionView {
    // View에 표시될 UI 요소들을 정의합니다.
    
    let cellIdentifier = "ListCellIdentifier"
    
    var items: [[String]] = [] // CollectionView에 표시될 아이템 배열 (구조체에 맞게 바꿔야 잘 들어오긴 할거같습니다)
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // 셀의 가로길이, 세로 길이 설정
        layout.itemSize = CGSize(width: 340, height: 100)
        
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(ListViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        backgroundColor = .white
        dataSource = self // CollectionView의 데이터 소스
        delegate = self // CollectionView의 델리게이트
    }
    
    required init?(coder: NSCoder) {
        fatalError("init 미구현")
    }
}

// ListView에 대한 UICollectionViewDataSource
extension ListView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count // 아이템 배열의 수를 반환.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ListViewCell
        // 셀의 내용 담기. 아마 생각보다는 많아질 예정
        cell.capitalLabel.text = items[indexPath.item][0] // 아이템의 첫 번째 인덱스를 capitalLabel에 출력
        cell.nowTemperatureLabel.text = items[indexPath.item][1] // 두 번째 인덱스를 nowTemperatureLabel에 출력
        cell.highTemperatureLabel.text = items[indexPath.item][2] // 세 번째 인덱스를 출력
        cell.lowTemperatureLabel.text = items[indexPath.item][3] // 동일
        cell.indexPath = indexPath // 셀의 indexPath 설정
        return cell
    }
}

// 셀 클릭 액션 (CellTapped) 별도 확장
extension ListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // 셀을 withDuration 시간에 걸쳐 scaleX만큼 크기 키우는 애니메이션
        UIView.animate(withDuration: 0.15, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }) { _ in
            // 애니메이션 완료 후 원래 크기로 되돌리기
            UIView.animate(withDuration: 0.15) {
                if let cell 
                    = collectionView.cellForItem(at: indexPath) {
                    cell.transform = .identity // withDuration 시간에 걸쳐 원래 크기로 되돌리기
                }
            }
        }
        
        // 클릭한 셀 정보출력 (임시)
        print("\(items[indexPath.item][0])의 메인 화면으로 이동합니다.") // 아이템의 인덱스 모두 출력
        
        // 0.2초의 딜레이 후에 탭바 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let tabBarController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController {
                
                // 탭바 전환 애니메이션 설정
                UIView.transition(with: tabBarController.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    tabBarController.selectedIndex = 0
                }, completion: nil)
            }
        }
    }
}
