//
//  TempListViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/16/24.
//

import UIKit
import RxSwift
import RxCocoa

class TempListViewController: UIViewController {
    
    var topView : UIView!
    var tableView: UITableView!
    var viewModel = TempListViewModel()
    var disposedBag = DisposeBag()
    
    let refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewConfigure()
        configureAlert()
        configurerefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.bookMarkModel = []
        self.viewModel.loadBookMark()
        self.viewModel.applySnapshot()
    }
    
    func tableViewConfigure(){
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
        tableView.refreshControl = refreshControl
        self.viewModel.applySnapshot()
    }
    
    func configurerefreshControl(){
        refreshControl.addTarget(self, action: #selector(refreshControlAction), for: .valueChanged)
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
                            // SpaceCellViewModel 생성 및 설정
                            let spaceCellViewModel = SpaceCellViewModel()
                            cell.configure(with: spaceCellViewModel)
                            cell.selectionStyle = .none
                            return cell
            case .listWeather(let listWeather):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(searchModel: listWeather)

                cell.rx.buttonTapped
                    .subscribe (onNext: { [ weak self ] in
                        self?.configureAlert()
                        self?.viewModel.willDeleteSearchModel = listWeather
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.selectionStyle = .none
                
                return cell
            }
        })
    }
    
    func configureAlert(){
        let backGroundView = UIView()
        backGroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backGroundView.frame = view.bounds
        let blurVisualEffectView = TSBlurEffectView()
        blurVisualEffectView.intensity = 0.1
        blurVisualEffectView.frame = view.bounds
        let alertView = DeleteAlertView()
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        if let window = windowScene?.windows.first {
            window.addSubview(backGroundView)
            backGroundView.alpha = 0
            backGroundView.addSubview(blurVisualEffectView)
            blurVisualEffectView.contentView.addSubview(alertView)
            blurVisualEffectView.alpha = 0
            
            UIView.animate(withDuration: 0.2) {
                backGroundView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
                backGroundView.alpha = 1
                
                blurVisualEffectView.intensity = 0.3
                blurVisualEffectView.alpha = 1
                
            }
        }
        alertView.snp.makeConstraints{
            $0.centerY.centerX.equalToSuperview()
            $0.height.equalTo(142)
            $0.width.equalTo(294)
        }
        alertView.cancelButton.rx
            .tap
            .subscribe(
                onNext: {[weak backGroundView, weak alertView] in
                    UIView.animate(withDuration: 0.2, animations: {
                        backGroundView?.alpha = 0
                        blurVisualEffectView.alpha = 0
                    }) { (_) in
                        backGroundView?.removeFromSuperview()
                        alertView?.disposeBag = DisposeBag()
                    }
                }).disposed(by: self.disposedBag)
        alertView.deleteButton.rx
            .tap
            .subscribe(
                onNext: {[weak backGroundView, weak alertView] in
                    UIView.animate(withDuration: 0.2, animations: {
                        backGroundView?.alpha = 0
                        blurVisualEffectView.alpha = 0
                    }) { (_) in
                        backGroundView?.removeFromSuperview()
                        alertView?.disposeBag = DisposeBag()
                        self.viewModel.deleteBookMark()
                    }
                }).disposed(by: self.disposedBag)
        
    }
    
    @objc func refreshControlAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.viewModel.applySnapshot()
            self.refreshControl.endRefreshing()
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
        
        viewModel.bookMarkModel.remove(at: sourceIndexPath.row)
        viewModel.bookMarkModel.insert(searchModel, at: destinationIndexPath.row)
        
        // UI를 업데이트합니다.
        viewModel.applySnapshot()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return 0 }
        switch item {
        case .currentWeather(_):
            return 159
        case .space:
            return 81
        case .listWeather(_):
            return 136
        }
    }
    
    // 셀 클릭 시 바운스 & 탭 바 전환 매서드
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return }
            switch item {
            case .currentWeather(let currentSearchModel) :
                // 0.2초의 딜레이 후에 탭바 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                    NotificationCenter.default.post(name: NSNotification.Name("SwitchTabNotification"), object: currentSearchModel, userInfo: nil)
                }
            case .listWeather(let searchModel):
                // 0.2초의 딜레이 후에 탭바 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
                    NotificationCenter.default.post(name: NSNotification.Name("SwitchTabNotification"), object: searchModel, userInfo: nil)
                }
            case .space:
                return
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

