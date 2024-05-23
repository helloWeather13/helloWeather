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
        setupNavbar()
        tableView.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        tableView.separatorColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        tableView.sectionIndexColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        tableView.sectionIndexTrackingBackgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.applySnapshot()
        if let existingAlertView = view.subviews.first(where: { $0.tag == 999 }) {
            existingAlertView.removeFromSuperview()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.bookMarkModel = []
        self.viewModel.loadBookMark()
        self.viewModel.applySnapshot()
    }
    
    override func setupAlertViewConstraints(_ customAlertView: UIView, image: UIImage, messageLabel: UILabel) {
        customAlertView.snp.makeConstraints { make in
          make.bottom.equalTo(view.snp.bottom).inset(91)
          make.centerX.equalToSuperview()
          make.height.equalTo(max(image.size.height, 40))
          make.width.equalTo(image.size.width + messageLabel.intrinsicContentSize.width + 30)
        }
      }
    
    func setupNavbar(){
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "나의 관심 지역"
            label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
            return label
        }()
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        let searchButton = UIBarButtonItem(image: UIImage(named: "search-0"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func searchButtonTapped() {
        let searchVC = SearchViewController()
        searchVC.delegate = HomeViewController()
        self.navigationController?.pushViewController(searchVC, animated: false)
        (self.navigationController?.parent as? MainViewController)?.scrollView.isScrollEnabled = false
    }
    
    func tableViewConfigure(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
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
                cell.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
                return cell
            case .listWeather(let listWeather):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {
                    return UITableViewCell()
                }
                cell.configure(searchModel: listWeather)
                cell.tempListViewController = self
                cell.rx.deleteViewTapped
                    .subscribe(onNext: { [weak self] in
                        self?.configureAlert()
                        self?.viewModel.willDeleteSearchModel = listWeather
                    })
                    .disposed(by: cell.disposeBag)
                cell.rx.buttonTapped
                    .subscribe (onNext: { [ weak self ] in
                        self?.configureAlert()
                        self?.viewModel.willDeleteSearchModel = listWeather
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.selectionStyle = .none
                cell.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
                
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
    func resetSwipeForCell(_ cell: ListTableViewCell) {
        // 스와이프 동작을 초기 상태로 되돌립니다.
        cell.didSwipeCellRight()
    }
}

extension TempListViewController: UITableViewDelegate {
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
        
        for cell in tableView.visibleCells {
            if let customCell = cell as? ListTableViewCell {
                resetSwipeForCell(customCell)
            }
        }
        
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
                NotificationCenter.default.post(name: NSNotification.Name("SwitchTabNotificationCurrent"), object: currentSearchModel, userInfo: nil)
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

extension TempListViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        // ListTableViewCell인 경우에만 드래그 항목을 생성합니다.
        guard let cell = tableView.cellForRow(at: indexPath), cell is ListTableViewCell else {
            return [] // CurrentWeatherTableViewCell 또는 SpaceTableViewCell에 대해서는 빈 배열을 반환하여 드래그를 제한합니다.
        }
        // ListTableViewCell에 대해서는 드래그 항목을 생성합니다.
        let itemProvider = NSItemProvider(object: "\(indexPath.section)-\(indexPath.row)" as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = indexPath
        
        guard let cell = tableView.cellForRow(at: indexPath) else { return [dragItem] }
        let cellInsetContents = cell.contentView.bounds.insetBy(dx: 2.0 , dy: 2.0)
        
        dragItem.previewProvider = {
            let dragPreviewParams = UIDragPreviewParameters()
            dragPreviewParams.visiblePath = UIBezierPath(roundedRect:cellInsetContents, cornerRadius: 15.0)
            return UIDragPreview(view: cell.contentView, parameters: dragPreviewParams)
        }
        return [dragItem]
    }
    
}


extension TempListViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        guard let destinationIndexPath = destinationIndexPath else {
            return UITableViewDropProposal(operation: .cancel)
        }
        
        // CurrentWeatherTableViewCell 또는 SpaceTableViewCell으로 드롭을 제한
        guard let cell = tableView.cellForRow(at: destinationIndexPath), !(cell is CurrentWeatherTableViewCell || cell is SpaceTableViewCell) else {
            return UITableViewDropProposal(operation: .forbidden)
        }
        
        return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath else { return }
        
        // CurrentWeatherTableViewCell 또는 SpaceTableViewCell으로 드롭을 제한
        guard let destinationCell = tableView.cellForRow(at: destinationIndexPath), !(destinationCell is CurrentWeatherTableViewCell || destinationCell is SpaceTableViewCell) else {
            return
        }
        
        // 아이템이 있는지 확인하고, 소스 인덱스 패스를 가져옵니다.
        guard let item = coordinator.items.first, let sourceIndexPath = item.sourceIndexPath else { return }
        
        // 테이블 뷰의 데이터 소스에 대한 변경 사항을 적용합니다.
        viewModel.moveBookMark(from: sourceIndexPath.row, to: destinationIndexPath.row)
        
        // 드롭된 아이템을 목적지에 드롭합니다.
        coordinator.drop(item.dragItem, toRowAt: destinationIndexPath)
    }
}

extension UIViewController {
    @objc func showCustomAlert(image: UIImage, message: String) {
        
        if let existingAlertView = view.subviews.first(where: { $0.tag == 999 }) {
            existingAlertView.removeFromSuperview()
        }
        
        // 사용자 정의 팝업 뷰를 만듭니다.
        let customAlertView = UIView()
        customAlertView.tag = 999
        customAlertView.backgroundColor = UIColor.black
        customAlertView.layer.cornerRadius = 8
        customAlertView.layer.shadowColor = UIColor.black.cgColor
        customAlertView.layer.shadowOpacity = 0.3
        customAlertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        customAlertView.layer.shadowRadius = 8
        
        
        // 이미지 뷰 설정
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        customAlertView.addSubview(imageView)
        
        // 메시지 레이블 설정
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        customAlertView.addSubview(messageLabel)
        
        self.view.addSubview(customAlertView)
        
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(image.size.width)
        }
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
//        customAlertView.snp.makeConstraints { make in
//            make.bottom.equalTo(self.view.snp.bottom).inset(91)
//            make.centerX.equalToSuperview()
//            make.height.equalTo(max(image.size.height, 40))
//            make.width.equalTo(image.size.width + messageLabel.intrinsicContentSize.width + 30)
//        }
        setupAlertViewConstraints(customAlertView, image: image, messageLabel: messageLabel)
        // 알럿 크기를 조절합니다.
        customAlertView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [.curveEaseInOut]) {
            customAlertView.transform = .identity
        } completion: { _ in
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
                
                customAlertView.removeFromSuperview()
            }
        }
    }
    
    @objc func setupAlertViewConstraints(_ customAlertView: UIView, image: UIImage, messageLabel: UILabel) {
        customAlertView.snp.makeConstraints { make in
          make.bottom.equalTo(view.snp.bottom)
          make.centerX.equalToSuperview()
          make.height.equalTo(max(image.size.height, 40))
          make.width.equalTo(image.size.width + messageLabel.intrinsicContentSize.width + 30)
        }
      }
}


