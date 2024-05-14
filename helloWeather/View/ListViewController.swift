//
//  ListViewController.swift
//  helloWeather
//
//  Created by Seungseop Lee on 5/13/24.
//

import Foundation
import UIKit
import SnapKit

class ListViewController: UIViewController {
    // MVVM에서 사용할 View와 ViewModel을 정의합니다.
    private var listView: ListView!
    private var listViewModel: ListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        
        
        // CollectionView의 delegate 설정
//        listView.delegate = self
    }
    
    // 사용자에게 보여지는 뷰 생성
    func configureUI() {
        // View 초기화
        listView = ListView()
        view.addSubview(listView)
        
        // Safe Area 기준으로 오토레이아웃을 설정
        listView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    // ViewModel과 View를 바인딩합니다.
    func bindViewModel() {
        // ViewModel을 초기화합니다.
        listViewModel = ListViewModel()
        // ViewModel과 View를 연결합니다.
        listView.items = listViewModel.items // CollectionView에 아이템을 설정합니다.
        listView.reloadData() // CollectionView를 다시 로드합니다.
    }
    
}

// 2차 시도
//extension ListViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//        swipeGesture.direction = .left
//        cell.addGestureRecognizer(swipeGesture)
//    }
//    
//    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//        guard let cell = gesture.view as? ListViewCell else { return }
//        guard let indexPath = listView.indexPath(for: cell) else { return }
//        
//        // 삭제할 아이템의 인덱스 저장
//        let deleteIndexPath = indexPath
//        
//        // 삭제할 아이템 확인
//        let deleteItem = listViewModel.items[deleteIndexPath.item]
//        
//        // 삭제 여부 확인 알럿
//        let alertController = UIAlertController(title: "확인", message: "\(deleteItem[0])을(를) 삭제하시겠습니까?", preferredStyle: .alert)
//        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
//        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
//            // 아이템 삭제
//            self.listViewModel.items.remove(at: deleteIndexPath.item)
//            // UI 업데이트
//            self.listView.deleteItems(at: [deleteIndexPath])
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(deleteAction)
//        present(alertController, animated: true, completion: nil)
//    }
//}



// 1차 시도
// UICollectionViewDelegate 프로토콜 확장
//extension ListViewController: UICollectionViewDelegate {
//    // 셀을 스와이프할 때 표시되는 작업을 정의
//    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath) -> [UIContextualAction]? {
//        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completion) in
//            // 삭제 작업을 수행합니다.
//            self?.deleteItem(at: indexPath)
//            completion(true)
//        }
//        deleteAction.backgroundColor = .red // 삭제 작업 배경색 설정
//        
//        return [deleteAction]
//    }
//    
//    // 셀을 삭제하는 메서드를 정의
//    func deleteItem(at indexPath: IndexPath) {
//        // 데이터 모델에서 항목을 삭제
//        listViewModel.items.remove(at: indexPath.item)
//        
//        // UI 업데이트를 위한 콜렉션 뷰 리로드
//        listView.reloadData()
//    }
//}
