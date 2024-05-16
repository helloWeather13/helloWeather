//
//  ListViewController.swift
//  helloWeather
//
//  Created by Seungseop Lee on 5/13/24.
//

import UIKit
import SnapKit
import Combine

class ListViewController: UIViewController, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    private var mainView: UIView!
    private var spacingView: UIView!
    private var collectionView: UICollectionView!
    private var listViewModel = ListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var destinationIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.3
        collectionView.addGestureRecognizer(longPressGesture)
        
        longPressGesture.require(toFail: collectionView.panGestureRecognizer)
        
        // 드래그 앤 드롭을 위한 delegate 설정
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        
        // destinationIndexPath 초기화
                destinationIndexPath = IndexPath()
    }
    
    func configureUI() {
        // Main View 설정
        mainView = UIView()
        mainView.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0) // 기본 배경색 설정
        mainView.layer.cornerRadius = 10 // 코너 라디우스 설정
        mainView.layer.masksToBounds = true // bounds 내부만 보이도록 설정
        mainView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainView)
        
        // SnapKit 제약 조건 설정
        mainView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide) // 상단을 safeArea로부터 0 포인트 띄움
            make.leading.equalToSuperview().offset(28) // 좌측을 28 포인트 띄움
            make.trailing.equalToSuperview().offset(-28) // 우측을 28 포인트 띄움
            make.height.equalTo(120) // 높이 120
        }
        
        // Label 설정 (주현님 현위치 날씨정보 받아오는 코드가 필요함...?)
        let label = UILabel()
        label.text = "메인 뷰입니다"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(label)
        
        // SnapKit 제약 조건 설정
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview() // mainView에 꽉 차게 설정
        }
        
        // Collection View 설정 (기존 코드와 동일)
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        let cellWidth: CGFloat = {
            let deviceWidth = UIScreen.main.bounds.width
            let inset: CGFloat = 28 // 좌우 inset을 28로 설정
            let numberOfLine: CGFloat = 1
            let width: CGFloat = (deviceWidth - inset * 2 - 1) / numberOfLine
            return width
        }()
        layout.itemSize = CGSize(width: cellWidth, height: 80) // 높이를 80으로 설정
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.cellIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        // Spacing View 설정
        spacingView = UIView()
        spacingView.backgroundColor = .red // 빨간색 배경 설정
        spacingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spacingView)
        
        // SnapKit 제약 조건 설정
        spacingView.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.bottom).offset(20)
            make.centerX.equalToSuperview() // 수평 중앙에 위치
            make.width.equalToSuperview().offset(-100) // 좌우 여백 50 포인트씩
            make.height.equalTo(2) // 높이 2
        }
        
        // SnapKit 제약 조건 설정
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(spacingView.snp.bottom).offset(20) // spacingView 아래에 20 포인트 간격
            make.leading.trailing.equalTo(mainView) // 좌우를 mainView에 맞춤
            make.bottom.equalTo(view.safeAreaLayoutGuide) // 하단을 safe area의 하단에 맞춤
        }
    }



    
    private func setupBindings() {
        listViewModel.$items.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        if gesture.state == .began {
            presentDeletionAlert(for: indexPath)
        }
    }
    
    func presentDeletionAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "해당 도시의 날씨 정보를 삭제합니다", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
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
        listViewModel.items.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}

extension ListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listViewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.cellIdentifier, for: indexPath) as! ListCollectionViewCell
        let item = listViewModel.items[indexPath.row]
        let searchModel = item.0
        let weatherModel = item.1
        cell.configure(with: searchModel, weatherModel: weatherModel)
        return cell
    }
}

extension ListViewController: UICollectionViewDelegate {
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        UIView.animate(withDuration: 0.15, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) {
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                if let cell = collectionView.cellForItem(at: indexPath) {
                    cell.transform = .identity
                }
            }
        }
        
        print("\(listViewModel.items[indexPath.row].0.fullAddress)의 메인 화면으로 이동합니다.")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
               let tabBarController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController {
                
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
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.15) {
                cell.transform = .identity
            }
        }
    }

}

extension ListViewController {
    // MARK: - UICollectionViewDragDelegate
    
    // 셀을 드래그하기 시작할 때 호출됩니다.
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // 드래그할 아이템을 생성하고 반환합니다.
        let itemProvider = NSItemProvider(object: "\(indexPath.section)-\(indexPath.item)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    // MARK: - UICollectionViewDropDelegate
    
    // 드롭 가능한 영역인지 여부를 반환합니다.
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    // 셀을 드롭할 때 호출됩니다.
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // 드롭한 위치에 대한 처리를 수행합니다.
        // 드롭한 위치가 셀 내부에 있는 경우
            if let indexPath = coordinator.destinationIndexPath {
                destinationIndexPath = indexPath
            } else {
                // 드롭한 위치가 셀 외부에 있는 경우
                let section = collectionView.numberOfSections - 1
                let row = collectionView.numberOfItems(inSection: section)
                destinationIndexPath = IndexPath(row: row, section: section)
            }
            
            // 아이템을 이동할 때 필요한 데이터를 가져옵니다.
            guard let item = coordinator.items.first,
                  let sourceIndexPath = item.sourceIndexPath else {
                return
            }
            
            // 아이템의 위치를 변경합니다.
            collectionView.performBatchUpdates({
                // 셀을 이동합니다.
                listViewModel.moveItem(from: sourceIndexPath.row, to: destinationIndexPath!.row)
                collectionView.moveItem(at: sourceIndexPath, to: destinationIndexPath!)
            }, completion: nil)
            
            // 해당 아이템의 드래그 상태를 완료합니다.
        coordinator.drop(item.dragItem, toItemAt: destinationIndexPath!)
    }
}

