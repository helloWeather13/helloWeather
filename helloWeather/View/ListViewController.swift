//
//  ListViewController.swift
//  helloWeather
//
//  Created by Seungseop Lee on 5/13/24.
//

import UIKit
import SnapKit
import Combine

class ListViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var listViewModel = ListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.3
        collectionView.addGestureRecognizer(longPressGesture)
        
        longPressGesture.require(toFail: collectionView.panGestureRecognizer)
    }
    
    func configureUI() {
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
        
        // SnapKit 제약 조건 설정
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(200) // 상단을 safeArea로부터 270 포인트 띄움
            make.leading.equalTo(view.snp.leading).offset(28) // 좌측을 28 포인트 띄움
            make.trailing.equalTo(view.snp.trailing).offset(-28) // 우측을 28 포인트 띄움
            make.bottom.equalTo(view.snp.bottom) // 하단을 부모 뷰의 하단에 맞춤 (제거해도 됨)
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
                    tabBarController.selectedIndex = 1
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
