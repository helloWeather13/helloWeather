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
        self.viewModel.applySnapshot()
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
                cell.selectionStyle = .none
                return cell
            }
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
