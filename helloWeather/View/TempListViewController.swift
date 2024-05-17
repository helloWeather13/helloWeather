//
//  TempListViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/16/24.
//

import UIKit

class TempListViewController: UIViewController {
    
    var topView : UIView!
    var tableView: UITableView!
    var viewModel = TempListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
    }
    
    func tableViewConfigure() {
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.identifier)
        tableView.register(SpaceTableViewCell.self, forCellReuseIdentifier: SpaceTableViewCell.identifier)
        tableView.register(CurrentWeatherTableViewCell.self, forCellReuseIdentifier: CurrentWeatherTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        configureDiffableDataSource()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(28)
        }
        self.viewModel.applySnapshot()
    }
    
    func configureDiffableDataSource() {
        self.viewModel.dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .currentWeather(let currentWeather):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherTableViewCell.identifier, for: indexPath) as? CurrentWeatherTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(searchModel: currentWeather)
                cell.selectionStyle = .none
                return cell
            case .space:
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SpaceTableViewCell.identifier, for: indexPath) as? SpaceTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure()
                cell.selectionStyle = .none
                return cell
            case .listWeather(let listWeather):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(searchModel: listWeather)
                cell.selectionStyle = .none
                return cell
            }
        })
    }
}

extension TempListViewController: UITableViewDelegate {
    
    // 셀 간 드래그 앤 드롭 이동 매서드
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 이동할 셀의 데이터를 가져옵니다.
        guard let itemToMove = self.viewModel.dataSource?.itemIdentifier(for: sourceIndexPath) else { return }
        
        // 새로운 위치로 셀의 데이터를 이동시킵니다.
        guard case let .listWeather(searchModel) = itemToMove else { return }
        
        viewModel.searchModel.remove(at: sourceIndexPath.row)
        viewModel.searchModel.insert(searchModel, at: destinationIndexPath.row)
        
        // UI를 업데이트합니다.
        viewModel.applySnapshot()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return 0 }
        switch item {
        case .currentWeather(_):
            return 138
        case .space:
            return 61
        case .listWeather(_):
            return 120
        }
    }
    
    // 셀 클릭 시 바운스 & 탭 바 전환 매서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return }
            switch item {
            case .listWeather(let searchModel):
                // 클릭한 셀 정보 출력 (임시)
                print("\(searchModel.fullAddress)의 메인 화면으로 이동합니다.")
                
                // 0.2초의 딜레이 후에 탭바 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    if let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                       let tabBarController = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController as? UITabBarController {
                        
                        // 탭바 전환 애니메이션 설정
                        UIView.transition(with: tabBarController.view, duration: 0.2, options: .transitionCrossDissolve, animations: {
                            tabBarController.selectedIndex = 0 // 변경할 탭의 인덱스
                        }, completion: nil)
                    }
                    // 클릭한 셀의 애니메이션
                    if let cell = tableView.cellForRow(at: indexPath) {
                        UIView.animate(withDuration: 0.15, animations: {
                            cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                        }) { _ in
                            UIView.animate(withDuration: 0.15) {
                                cell.transform = .identity
                            }
                        }
                    }
                }
                
            default:
                break
            }
        
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .listWeather(_):
            // 셀을 클릭하면 애니메이션을 적용
            if let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.15, animations: {
                    cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                }) { _ in
                    UIView.animate(withDuration: 0.15) {
                        cell.transform = .identity
                    }
                }
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return }
        if case .listWeather(_) = item {
            if let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.15) {
                    cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return }
        if case .listWeather(_) = item {
            if let cell = tableView.cellForRow(at: indexPath) {
                UIView.animate(withDuration: 0.15) {
                    cell.transform = .identity
                }
            }
        }
    }
    
    
}
