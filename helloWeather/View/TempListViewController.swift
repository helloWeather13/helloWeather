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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.applySnapshot()
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
                if let selectedCell = tableView.cellForRow(at: indexPath) as? ListTableViewCell {
                    UIView.animate(withDuration: 0.15, animations: {
                        selectedCell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    }) { _ in
                        UIView.animate(withDuration: 0.15) {
                            selectedCell.transform = .identity
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
            dragPreviewParams.visiblePath = UIBezierPath(roundedRect:cellInsetContents, cornerRadius: 8.0)
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
    func showCustomAlert(image: UIImage, message: String) {
        // 사용자 정의 팝업 뷰를 만듭니다.
        //        let customAlertView = UIView(frame: CGRect(x: 20, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width - 40, height: 100))
        let customAlertView = UIView()
        customAlertView.backgroundColor = UIColor.black
        customAlertView.layer.cornerRadius = 8
        customAlertView.layer.shadowColor = UIColor.black.cgColor
        customAlertView.layer.shadowOpacity = 0.3
        customAlertView.layer.shadowOffset = CGSize(width: 0, height: 5)
        customAlertView.layer.shadowRadius = 8
        
        // 이미지 뷰 설정
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        //        customAlertView.addSubview(imageView)
        
        // 메시지 레이블 설정
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        //        customAlertView.addSubview(messageLabel)
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillProportionally
            stackView.addArrangedSubview(imageView)
            stackView.addArrangedSubview(messageLabel)
            return stackView
        }()
        customAlertView.addSubview(stackView)
        self.view.addSubview(customAlertView)
        
        customAlertView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view.snp.bottom).inset(90)
            make.centerX.equalToSuperview()
            make.height.equalTo(40).priority(.high)
            make.leading.greaterThanOrEqualTo(self.view.snp.leading).offset(20)
            make.trailing.lessThanOrEqualTo(self.view.snp.trailing).offset(-20)
        }
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        // 이미지 뷰와 메시지 레이블의 비율 설정
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        messageLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        // 이미지 뷰의 최대 너비를 설정하여 크기 조정
        imageView.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width).multipliedBy(0.2).priority(.high)
            make.height.lessThanOrEqualTo(20) // 이미지 뷰의 최대 높이 제한
        }
        
        // 메시지 레이블의 최소 너비를 설정하여 크기 조정
        messageLabel.snp.makeConstraints { make in
            make.width.equalTo(stackView.snp.width).multipliedBy(0.8).priority(.high)
        }
        
        //        imageView.snp.makeConstraints { make in
        //            make.leading.equalToSuperview().inset(10)
        //            make.centerY.equalToSuperview()
        //        }
        //        messageLabel.snp.makeConstraints { make in
        //            make.leading.equalTo(imageView.snp.trailing).offset(1)
        //            make.trailing.equalToSuperview().inset(10)
        //            make.centerY.equalToSuperview()
        //        }
        
        
        //        NSLayoutConstraint.activate([
        //            imageView.topAnchor.constraint(equalTo: customAlertView.topAnchor, constant: 10),
        //            imageView.centerXAnchor.constraint(equalTo: customAlertView.centerXAnchor),
        //            imageView.widthAnchor.constraint(equalToConstant: 40),
        //            imageView.heightAnchor.constraint(equalToConstant: 40),
        //
        //            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
        //            messageLabel.leadingAnchor.constraint(equalTo: customAlertView.leadingAnchor, constant: 10),
        //            messageLabel.trailingAnchor.constraint(equalTo: customAlertView.trailingAnchor, constant: -10),
        //            messageLabel.bottomAnchor.constraint(equalTo: customAlertView.bottomAnchor, constant: -10)
        //        ])
        
        // 뷰 컨트롤러의 뷰에 사용자 정의 팝업 뷰를 추가합니다.
        
        
        //        // 사용자 정의 팝업 뷰를 화면 아래로 이동시킵니다.
        //        UIView.animate(withDuration: 0.5, animations: {
        //            customAlertView.frame.origin.y -= 200
        //        })
        
        // 일정 시간이 지난 후 사용자 정의 팝업 뷰를 자동으로 닫습니다.
        //                Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
        //                    UIView.animate(withDuration: 0.5, animations: {
        //                        customAlertView.frame.origin.y += customAlertView.frame.height
        //                    }) { _ in
        //                        customAlertView.removeFromSuperview()
        //                    }
        //                }
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            customAlertView.removeFromSuperview()
        }
    }
}
