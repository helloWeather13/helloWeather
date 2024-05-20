//
//  HomeViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import UIKit
import SnapKit
import Lottie

class HomeViewController: UIViewController {
    
    let homeViewModel = HomeViewModel()
    
    var bookmarkButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(named: "bookmark_S-0"), for: .normal)
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var notificationButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var rssIcon = UIImageView(image: UIImage(named: "rss"))
    
    var lastUpdateLabel: UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let formatted = dateFormatter.string(from: Date())
        label.text = "마지막 업데이트 \(formatted)"
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = #colorLiteral(red: 0.3960784078, green: 0.3960784078, blue: 0.3960784078, alpha: 1)
        return label
    }()
    
    lazy var updateStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [rssIcon, lastUpdateLabel])
        stview.axis = .horizontal
        stview.spacing = 3
        return stview
    }()
    
    var todayLabel: UILabel = {
        let label = UILabel()
        label.text = "오늘은"
        label.font = UIFont(name: "GmarketSansTTFLight", size: 32)
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
        label.text = ""
        label.font = UIFont(name: "Montserrat-Black", size: 136)
        return label
    }()
    
    var unitLabel: UILabel = {
        let label = UILabel()
        label.text = "º"
        label.font = UIFont(name: "Montserrat-Black", size: 136)
        return label
    }()
    
    var scrollAnimation: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "Scroll")
        lottie.alpha = 1
        return lottie
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
            let titleView = UIView()
            
            let imageView = UIImageView(image: UIImage(named: "navigation"))
            imageView.contentMode = .scaleAspectFit
            
            let titleLabel: UILabel = {
                let label = UILabel()
                label.text = address
                label.font = .boldSystemFont(ofSize: 16)
                return label
            }()
            
            let stackView: UIStackView = {
                let stview = UIStackView(arrangedSubviews: [imageView, titleLabel])
                stview.axis = .horizontal
                stview.spacing = 2
                stview.alignment = .center
                return stview
            }()
                    
            titleView.addSubview(stackView)
            stackView.snp.makeConstraints {
                $0.centerX.centerY.equalTo(titleView)
            }
            titleView.sizeToFit()
            self.navigationItem.titleView = titleView
        }
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "search-0"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func searchButtonTapped() {
        print(#function)
    }
    
    func setupSecondLabel() {
        homeViewModel.differenceOnCompleted = { [unowned self] _ in
            thermometerIcon.image = homeViewModel.compareDescription.1
            
            let yesterday = NSAttributedString(string: homeViewModel.yesterdayString, attributes: [
                NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFLight", size: 32)
            ])
            let compare = NSAttributedString(string: homeViewModel.compareDescription.0, attributes: [
                NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 32)
            ])
            let compareStr = NSMutableAttributedString()
            compareStr.append(yesterday)
            compareStr.append(compare)
            compareLabel.attributedText = compareStr
            
            temperatureLabel.text = String(Int(homeViewModel.todayFeelsLike)) + "º"
        }
    }
    
    func setupThirdLabel() {
        homeViewModel.estimatedOnCompleted = { [unowned self] in
            weatherIcon.image = homeViewModel.condition.detail(sunrise: homeViewModel.sunriseNum, sunset: homeViewModel.sunsetNum, now: homeViewModel.now).icon
            
            let condition = NSAttributedString(string: homeViewModel.condition.rawValue, attributes: [
                NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFBold", size: 32)
            ])
            let verb = NSAttributedString(string: homeViewModel.condition.detail(sunrise: homeViewModel.sunriseNum, sunset: homeViewModel.sunsetNum, now: homeViewModel.now).verb, attributes: [
                NSAttributedString.Key.font: UIFont(name: "GmarketSansTTFLight", size: 32)
            ])
            let weatherStr = NSMutableAttributedString()
            weatherStr.append(condition)
            weatherStr.append(verb)
            weatherLabel.attributedText = weatherStr
        }
    }
    
    func setupAutoLayout() {
         
        view.addSubview(updateStackView)
        updateStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(128)
            $0.leading.equalToSuperview().offset(32)
        }
        
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
            $0.leading.equalToSuperview().offset(140)
        }
        
//        view.addSubview(unitLabel)
//        unitLabel.snp.makeConstraints {
//            $0.top.equalTo(stackView.snp.bottom).offset(112)
//            $0.leading.equalTo(temperatureLabel.snp.trailing).inset(3)
//        }
        
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
        
        view.addSubview(scrollAnimation)
        scrollAnimation.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(96)
            $0.centerX.equalToSuperview()
        }
        
        scrollAnimation.loopMode = .repeat(4)
        scrollAnimation.play { _ in
            UIView.animate(withDuration: 0.5, animations: {
            self.scrollAnimation.alpha = 1
          }, completion: nil)
        }
    }
    
    @objc func bookmarkButtonTapped() {
        if !homeViewModel.isBookmarked {
            homeViewModel.isBookmarked = true
            bookmarkButton.setBackgroundImage(UIImage(named: "bookmark_S-1"), for: .normal)

            UIView.animate(withDuration: 0.5, animations: {
                self.notificationButton.setBackgroundImage(UIImage(named: "notification_S-0"), for: .normal)
                self.notificationButton.snp.updateConstraints {
                    $0.top.equalToSuperview().offset(160)
                }
                self.view.layoutIfNeeded()
            })
        } else {
            homeViewModel.isBookmarked = false
            bookmarkButton.setBackgroundImage(UIImage(named: "bookmark_S-0"), for: .normal)
            UIView.animate(withDuration: 0.5, animations: {
                self.notificationButton.setBackgroundImage(nil, for: .normal)
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
