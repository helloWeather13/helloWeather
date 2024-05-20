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
        tableView.snp.makeConstraints{make in
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
                guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrentWeatherTableViewCell.identifier, for: indexPath) as? CurrentWeatherTableViewCell else{
                    return UITableViewCell()
                }
                cell.configure(searchModel: currentWeather)
                cell.selectionStyle = .none
                return cell
            case .space :
                guard let cell = tableView.dequeueReusableCell(withIdentifier: SpaceTableViewCell.identifier, for: indexPath) as? SpaceTableViewCell else{
                    return UITableViewCell()
                }
                cell.configure()
                cell.selectionStyle = .none
                return cell
            case .listWeather(let listWeather):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else{
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


extension TempListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return 0}
        switch item {
        case .currentWeather( _):
            return 134
        case .space:
            return 61
        case .listWeather( _):
            return 118
        }
        
    }
}
