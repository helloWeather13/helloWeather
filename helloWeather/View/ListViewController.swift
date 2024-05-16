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
    private var tableView: UITableView!
    private var listViewModel = ListViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupBindings()
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.3
        tableView.addGestureRecognizer(longPressGesture)
        
        longPressGesture.require(toFail: tableView.panGestureRecognizer)
    }
    
    func configureUI() {
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        listViewModel.$items.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.tableView.reloadData()
        }.store(in: &cancellables)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else {
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
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listViewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.cellIdentifier, for: indexPath) as! ListTableViewCell
        let item = listViewModel.items[indexPath.row]
        let searchModel = item.0
        let weatherModel = item.1
        cell.configure(with: searchModel, weatherModel: weatherModel)
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        UIView.animate(withDuration: 0.15, animations: {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                if let cell = tableView.cellForRow(at: indexPath) {
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
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.15) {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            UIView.animate(withDuration: 0.15) {
                cell.transform = .identity
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 // 셀의 높이를 80으로 지정
    }
    
    // 간격주고싶어서 만들어본 푸터 (근데안됨)
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            // footer를 생성하여 반환
            let footerView = UIView()
            footerView.backgroundColor = .clear
            return footerView
        }
        
        func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
            // 각 섹션의 footer 높이를 설정하여 간격 조절
            return 50
        }
    
    // 테이블 뷰 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                // 데이터 모델에서 해당 항목을 삭제합니다.
                listViewModel.items.remove(at: indexPath.row)
                
                // 테이블 뷰에서 해당 행을 삭제합니다.
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
}
