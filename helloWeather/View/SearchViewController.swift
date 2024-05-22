//
//  SearchViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import MapKit

protocol TransferDataToMainDelegate {
    func searchDidTouched(searchModel : SearchModel)
}
class SearchViewController: UIViewController {
    var viewModel = SearchViewModel()
    var disposeBag = DisposeBag()
    var delegate : TransferDataToMainDelegate?
    var searchBar: UISearchBar!
    var titleLabel : UILabel!
    var tableView: UITableView!
    let emptyView = EmptySearchView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        searchBarConfigure()
        tableViewConfigure()
        configureEmptyView()
    }
    
    func configure() {
        self.view.backgroundColor = .systemBackground
        self.navigationItem.hidesBackButton = true

        // Create a custom button view
        let deleteButton = UIView()
        deleteButton.frame = CGRect(x: 0, y: 0, width: 48, height: 36)
        deleteButton.isUserInteractionEnabled = true // Enable user interaction

        // Create the label for the button
        let cancelText = UILabel()
        cancelText.text = "취소"
        cancelText.font = .systemFont(ofSize: 18)
        cancelText.textColor = .label
        deleteButton.addSubview(cancelText)

        // Add constraints to the label
        cancelText.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }

        // Add a tap gesture recognizer to the deleteButton
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTap))
        deleteButton.addGestureRecognizer(tapGesture)

        // Create the UIBarButtonItem with the custom view
        let barButton = UIBarButtonItem(customView: deleteButton)
        navigationItem.rightBarButtonItem = barButton
    }

    @objc func cancelButtonTap() {
        navigationController?.popViewController(animated: false)
    }
    func configureEmptyView(){
        emptyView.frame = view.bounds
        self.view.addSubview(emptyView)
        emptyView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        self.emptyView.isHidden = true
    }
    func tableViewConfigure(){
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.register(RelatedSearchTableViewCell.self, forCellReuseIdentifier: RelatedSearchTableViewCell.identifier)
        tableView.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 12
        configureDiffableDataSource()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        self.viewModel.applySnapshot()
    }
    
    
    func configureDiffableDataSource() {
        self.viewModel.dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .recentSearch(let recentSearch):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.identifier, for: indexPath) as? RecentSearchTableViewCell else{
                    return UITableViewCell()
                }
                cell.configureUI(text: recentSearch.fullAddress)
                cell.selectionStyle = .none
                return cell
            case .relatedSearch(let relatedSearch):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RelatedSearchTableViewCell.identifier, for: indexPath) as? RelatedSearchTableViewCell else{
                    return UITableViewCell()
                }
                cell.configureUI(text: relatedSearch.fullAddress, keyword: relatedSearch.keyWord)
                cell.selectionStyle = .none
                return cell
            }
        })
    }
    
    func searchBarConfigure(){
        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "어느 지역의 날씨가 궁금하세요?"
        searchBar.setValue("취소", forKey: "cancelButtonText")
        searchBar.showsCancelButton = false
        searchBar.tintColor = UIColor.label
        searchBarTextFieldConfigure()
        self.navigationItem.titleView = searchBar
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
                }).disposed(by: self.disposeBag)
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
                        self.viewModel.deleteRecentSearch()
                    }
                }).disposed(by: self.disposeBag)
        
    }
    func searchBarTextFieldConfigure(){
        searchBar.searchTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.01)
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchBar.searchTextField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha:0.06).cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.setLeftImage(UIImage(named: "search-1")!)
        searchBar.rx.text.orEmpty
            .skip(1)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] text in
                if !text.isEmpty{
                    self?.viewModel.searchCompleter?.queryFragment = text
                    self?.viewModel.getSearchResult(address: text, completion: { check in
                        if check {
                            self?.emptyView.isHidden = false
                        }else{
                            self?.emptyView.isHidden = true
                        }
                    })
                    self?.viewModel.state = .searching
                }else{
                    self?.emptyView.isHidden = true
                    self?.viewModel.state = .beforeSearch
                    self?.viewModel.applySnapshot()
                }
                
            }).disposed(by: disposeBag)
    }
}

extension SearchViewController : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.identifier) as? SectionHeaderView else{
            return UIView()
        }
        header.configure(section: section, state: self.viewModel.state)
        header.button.rx.tap
            .bind {
                self.configureAlert()
            }
            .disposed(by: disposeBag)
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return }
        switch item {
        case.recentSearch(let recentSearch):
            self.delegate?.searchDidTouched(searchModel: recentSearch)
            navigationController?.popViewController(animated: false)
        case .relatedSearch(let relatedSearch):
            self.delegate?.searchDidTouched(searchModel: relatedSearch)
            self.searchBar.resignFirstResponder()
            self.viewModel.appendRecentSearch(data: relatedSearch)
            navigationController?.popViewController(animated: false)
        }
    }
    
}
