//
//  HomeViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let homeViewModel = HomeViewModel()
    
    var bookmarkButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(HomeViewController.self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var notificationButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .clear
        button.addTarget(HomeViewController.self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은"
        label.font = .systemFont(ofSize: 36, weight: .ultraLight)
        return label
    }()
    
    var compareLabel = UILabel()
    
    var thermometerIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .black
        return icon
    }()
    
    lazy var secondLabel: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [compareLabel, thermometerIcon])
        stview.axis = .horizontal
        stview.spacing = 3
        return stview
    }()
    
    var weatherIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .black
        return icon
    }()
    
    var weatherLabel = UILabel()
    
    lazy var thirdLabel: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [weatherIcon, weatherLabel])
        stview.axis = .horizontal
        stview.spacing = 3
        return stview
    }()
    
    lazy var stackView: UIStackView = {
       let stview = UIStackView(arrangedSubviews: [todayLabel, secondLabel, thirdLabel])
        stview.spacing = 10
        stview.axis = .vertical
        stview.alignment = .leading
        stview.distribution = .fillEqually
        return stview
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "23"
        label.font = .systemFont(ofSize: 120, weight: .heavy)
        return label
    }()
    
    var unitLabel: UILabel = {
        let label = UILabel()
        label.text = "º"
        label.font = .systemFont(ofSize: 120, weight: .heavy)
        return label
    }()
    
    var scrollAnimation: UIImage = {
        let image = UIImage()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupSecondLabel()
        setupThirdLabel()
        setupAutoLayout()
    }

    func setupNaviBar() {
        
        
        homeViewModel.addressOnCompleted = { [unowned self] address in
            self.navigationItem.title = address
        }
        
        
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        print(#function)
    }
    
    func setupSecondLabel() {
        homeViewModel.differenceOnCompleted = { [unowned self] _ in
            thermometerIcon.image = homeViewModel.compareDescription.1
            
            let yesterday = NSAttributedString(string: homeViewModel.yesterdayString, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .ultraLight)
            ])
            let compare = NSAttributedString(string: homeViewModel.compareDescription.0, attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)
            ])
            let compareStr = NSMutableAttributedString()
            compareStr.append(yesterday)
            compareStr.append(compare)
            compareLabel.attributedText = compareStr
            
            temperatureLabel.text = String(Int(homeViewModel.todayFeelsLike))
        }
    }
    
    func setupThirdLabel() {
        homeViewModel.conditionOnCompleted = { [unowned self] in
            weatherIcon.image = homeViewModel.condition.icon
            
            let condition = NSAttributedString(string: homeViewModel.condition.rawValue, attributes: [
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 36)
            ])
            let verb = NSAttributedString(string: homeViewModel.condition.verb, attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36, weight: .ultraLight)
            ])
            let weatherStr = NSMutableAttributedString()
            weatherStr.append(condition)
            weatherStr.append(verb)
            weatherLabel.attributedText = weatherStr
        }
    }
    
    func setupAutoLayout() {
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(210)
            $0.leading.equalToSuperview().offset(30)
        }
        
        thermometerIcon.snp.makeConstraints {
            $0.width.height.equalTo(36)
        }
        
        weatherIcon.snp.makeConstraints {
            $0.width.height.equalTo(36)
        }
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(108)
            $0.leading.equalToSuperview().offset(149)
        }
        
        view.addSubview(unitLabel)
        unitLabel.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom).offset(112)
            $0.leading.equalTo(temperatureLabel.snp.trailing).offset(4)
        }
        
        view.addSubview(notificationButton)
        notificationButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(128)
            $0.trailing.equalToSuperview().inset(32)
            $0.width.height.equalTo(24)
        }
        
        view.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(128)
            $0.trailing.equalToSuperview().inset(32)
            $0.width.height.equalTo(24)
        }
    }
    
    @objc func bookmarkButtonTapped() {
        if !homeViewModel.isBookmarked {
            homeViewModel.isBookmarked = true
            bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.notificationButton.tintColor = .black
                self.notificationButton.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(172)
                }
                self.view.layoutIfNeeded()
            })
        } else {
            homeViewModel.isBookmarked = false
            bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            UIView.animate(withDuration: 0.3, animations: {
                self.notificationButton.tintColor = .clear
            }) { _ in
                self.notificationButton.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(128)
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    @objc func notificationButtonTapped() {
        print(#function)
    }
    
}
