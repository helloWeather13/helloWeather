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
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.identifier)
        tableView.separatorStyle = .none
        configureDiffableDataSource()
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{make in
            make.edges.equalToSuperview().inset(10)
        }
        self.viewModel.applySnapshot()
    }
    
    func configureDiffableDataSource() {
        self.viewModel.dataSource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            switch item {
            case .recentSearch(let _):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: RelatedSearchTableViewCell.identifier, for: indexPath) as? RelatedSearchTableViewCell else{
                    return UITableViewCell()
                }
                cell.selectionStyle = .none
                cell.isHidden = true
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
        searchBar.tintColor = .red
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: {[weak self] text in
                if !text.isEmpty{
                    self?.viewModel.getKakaoAddressResult(address: text)
                    self?.viewModel.state = .searching
                }else{
                    self?.viewModel.state = .beforeSearch
                    self?.viewModel.applySnapshot()
                }
                
            }).disposed(by: disposeBag)
        self.navigationItem.titleView = searchBar
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
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = self.viewModel.dataSource?.itemIdentifier(for: indexPath) else { return }
        switch item {
        case.recentSearch(_):
            return
        case .relatedSearch(let data):
            self.searchBar.resignFirstResponder()
            self.viewModel.getWeather(lat: String(data.lat), lon: String(data.lon))
        }
    }
    
}
