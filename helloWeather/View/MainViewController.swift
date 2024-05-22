//
//  MainViewController.swift
//  helloWeather
//
//  Created by CaliaPark on 5/21/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    var scrollView: UIScrollView!
    
    var firstVC: UINavigationController!
    var secondVC: UINavigationController!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        view.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupRefreshControl()
    }
    
    func setupNaviBar() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        firstVC = UINavigationController(rootViewController: HomeViewController())
        secondVC = UINavigationController(rootViewController: TabViewController2())
        
        addChild(firstVC)
        addChild(secondVC)
        
        scrollView.addSubview(firstVC.view)
        scrollView.addSubview(secondVC.view)
        
        firstVC.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        
        secondVC.view.snp.makeConstraints { make in
            make.top.equalTo(firstVC.view.snp.bottom)
            make.leading.trailing.bottom.equalTo(scrollView)
            make.width.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.safeAreaLayoutGuide)
        }
        
        firstVC.didMove(toParent: self)
        secondVC.didMove(toParent: self)
    }
    
    func setupRefreshControl() {
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(self.refreshFunc), for: .valueChanged)
    }
    
    @objc func refreshFunc() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            if let homeVC = self.firstVC.viewControllers.first as? HomeViewController {
                homeVC.setupNaviBar()
                homeVC.setupLastUpdateLabel()
                homeVC.setupSecondLabel()
                homeVC.setupThirdLabel()
            }
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
}
