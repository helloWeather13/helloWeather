//
//  ListViewController.swift
//  helloWeather
//
//  Created by Seungseop Lee on 5/13/24.
//

import Foundation
import UIKit
import SnapKit
import Combine


// MARK: - ListCollectionView

class ListViewController: UIViewController {
    // MVVM에서 사용할 View와 ViewModel을 정의합니다.
    private var listCollectionView: UICollectionView!
    //    private var listView: ListView!
    private var listViewModel = ListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.listViewModel.configureData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.3
        listCollectionView.addGestureRecognizer(longPressGesture)
        
        longPressGesture.require(toFail: listCollectionView.panGestureRecognizer)
        
        // CollectionView의 delegate 설정
        //        listView.delegate = self
    }
    
    // 사용자에게 보여지는 뷰 생성
    func configureUI() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 340, height: 100)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        listCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        listCollectionView.dataSource = self
        listCollectionView.delegate = self
        listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.cellIdentifier)
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        // View 초기화
        //        listView = ListView()
        view.addSubview(listCollectionView)
        
        // Safe Area 기준으로 오토레이아웃을 설정
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    // ViewModel과 View를 바인딩합니다.
    
    private func setupBindings() {
        listViewModel.$items.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.listCollectionView.reloadData()
        }.store(in: &cancellables)
        
    }
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: listCollectionView)
        guard let indexPath = listCollectionView.indexPathForItem(at: point) else {
            return
        }
        if gesture.state == .began {
            presentDeletionAlert(for: indexPath)
        }
    }
    
    func presentDeletionAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "담은 도시를 삭제합니다", message: "정말 삭제 하시겠어요?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { [weak self] _ in
            guard let self = self else {return}
            self.deleteItem(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deleteItem(at indexPath: IndexPath) {
        //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        //        let context = appDelegate.persistentContainer.viewContext
        //        let bookToDelete = books[indexPath.row]
        //
        //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BookData")
        //        fetchRequest.predicate = NSPredicate(format: "title == %@", bookToDelete.title)
        listViewModel.items.remove(at: indexPath.row)
        listCollectionView.deleteItems(at: [indexPath])
        
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.items.count // 아이템 배열의 수를 반환.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.cellIdentifier, for: indexPath) as! ListCollectionViewCell
        let item = listViewModel.items[indexPath.item]
        // 셀의 내용 담기. 아마 생각보다는 많아질 예정
        cell.capitalLabel.text = item.0.city
        cell.nowTemperatureLabel.text = String(item.1.forecast.forecastday[0].day.avgtempC)
        cell.highTemperatureLabel.text = String(item.1.forecast.forecastday[0].day.maxtempC)
        cell.lowTemperatureLabel.text = String(item.1.forecast.forecastday[0].day.mintempC)
        cell.indexPath = indexPath
        //        cell.capitalLabel.text = listViewModel.items[indexPath.item][0] // 아이템의 첫 번째 인덱스를 capitalLabel에 출력
        //        cell.nowTemperatureLabel.text = listViewModel.items[indexPath.item][1] // 두 번째 인덱스를 nowTemperatureLabel에 출력
        //        cell.highTemperatureLabel.text = listViewModel.items[indexPath.item][2] // 세 번째 인덱스를 출력
        //        cell.lowTemperatureLabel.text = listViewModel.items[indexPath.item][3] // 동일
        //        cell.indexPath = indexPath // 셀의 indexPath 설정
        return cell
    }
}

// 셀 클릭 액션 (CellTapped) 별도 확장
extension ListViewController: UICollectionViewDelegate {
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
                if let cell = collectionView.cellForItem(at: indexPath) {
                    cell.transform = .identity // withDuration 시간에 걸쳐 원래 크기로 되돌리기
                }
            }
        }
        
        // 클릭한 셀 정보출력 (임시)
        print("\(listViewModel.items[indexPath.item].0.fullAddress)의 메인 화면으로 이동합니다.") // 아이템의 인덱스 모두 출력
        
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
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.15) {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }
    // 애니메이션 해제
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.15) {
                cell.transform = .identity
            }
        }
    }
    
}



