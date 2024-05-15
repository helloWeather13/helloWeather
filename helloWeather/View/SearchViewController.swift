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

class SearchViewController: UIViewController {
    var viewModel = SearchViewModel()
    var disposeBag = DisposeBag()
    
    var searchBar: UISearchBar!
    var titleLabel : UILabel!
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarConfigure()
        tableViewConfigure()
        //searchViewModel.getResult(apiModel : searchViewModel.kakaoAddress, expecting: KakaoAddressModel.self)
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
        searchBar.showsCancelButton = true
        searchBar.tintColor = .label
        searchBarTextFieldConfigure()
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarTextFieldConfigure(){
        searchBar.searchTextField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.01)
        searchBar.searchTextField.font = UIFont.systemFont(ofSize: 14)
        searchBar.searchTextField.layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha:0.06).cgColor
        searchBar.searchTextField.layer.borderWidth = 1
        searchBar.searchTextField.layer.cornerRadius = 10
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.setLeftImage(UIImage(systemName: "fan.floor")!)
        searchBar.rx.text.orEmpty
            .skip(1)
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] text in
                if !text.isEmpty{
                    self?.viewModel.getSearchResult(address: text)
                    self?.viewModel.state = .searching
                }else{
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
                self.viewModel.deleteRecentSearch()
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
            self.viewModel.getWeatherResult(searchModel: recentSearch)
        case .relatedSearch(let relatedSearch):
            self.searchBar.resignFirstResponder()
            self.viewModel.appendRecentSearch(data: relatedSearch)
            self.viewModel.getWeatherResult(searchModel: relatedSearch)
        }
    }
    
}
