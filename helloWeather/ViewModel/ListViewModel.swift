//
//  ListViewModel.swift
//  helloWeather
//
//  Created by Seungseop Lee on 5/13/24.
//

import Foundation
import UIKit

// 구조체에 담을 필요한 정보가 총 5개이긴한데, 지금 받아올 수단이 없어서 보류입니다.
struct tempWeather {
    var capital: String
    var nowTemperature: String
    var highTemperature: String
    var lowTemperature: String
    var weatherImage: UIImage?
}

class ListViewModel {
    
    // MVVM 아키텍처를 따르기 위해 변경사항을 감지하고 이를 뷰에 반영하기 위한 코드
    var items: [[String]] = [] {
            didSet {
                // 아이템이 변경되면 업데이트를 알리도록 구현
                NotificationCenter.default.post(name: Notification.Name("ListViewModelItemsUpdated"), object: nil)
            }
        }
        
        init() {
            // 임시 데이터(아이템) 아마 데이터가 이렇게 담겨있지는 않을텐데 일단은 그렇습니다.
            items = [["강남구", "25", "27", "23"],
                     ["강동구", "25", "27", "23"],
                     ["강북구", "25", "27", "23"],
                     ["강서구", "25", "27", "23"],
                     ["성북구", "25", "27", "23"],
                     ["광진구", "25", "27", "23"]]
        }
    // ViewModel에서 사용할 데이터 및 비즈니스 로직을 포함시킵니다.
    
    // 임시 데이터(아이템) 아마 데이터가 이렇게 담겨있지는 않을텐데 일단은 그렇습니다.
//    var items: [[String]] = [["Item 1", "아이템 1번입니다"],
//                             ["Item 2", "아이템 2번입니다"],
//                             ["Item 3", "아이템 3번입니다"],
//                             ["Item 4", "아이템 4번입니다"],
//                             ["Item 5", "아이템 5번입니다"],
//                             ["Item 6", "아이템 6번입니다"],
//                             ["테스트 1", "테스트 1번입니다"]]
    
    
    
    // ViewModel에 아이템을 추가
    func addItem(_ item: String, description: String) {
        items.append([item, description])
    }
    
    // 해당 아이템의 수만큼 컬렉션 뷰 생성
    func numberOfItems() -> Int {
        return items.count
    }
}

