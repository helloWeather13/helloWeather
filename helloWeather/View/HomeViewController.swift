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
        button.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var notificationButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var weatherIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "umbrella")
        imageView.tintColor = .black
        return imageView
    }()
    
    var yesterdayLabel: UILabel = {
        let label = UILabel()
        label.text = "어제보다"
        label.font = .systemFont(ofSize: 50, weight: .ultraLight)
        label.textAlignment = .left
        return label
    }()
    
    var difference = NSAttributedString(string: "-2º", attributes: [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 50.0)
    ])
    var lessMore = NSAttributedString(string: "도 낮고", attributes: [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50.0, weight: .ultraLight)
    ])
    
    lazy var compareLabel: UILabel = {
        let label = UILabel()
        let combinedString = NSMutableAttributedString()
        combinedString.append(difference)
        combinedString.append(lessMore)
        label.attributedText = combinedString
        return label
    }()
    
    
    var condition = NSAttributedString(string: "비", attributes: [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 50.0)
    ])
    var verb = NSAttributedString(string: "가 올거에요", attributes: [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50.0, weight: .ultraLight)
    ])
    
    lazy var weatherLabel: UILabel = {
        let label = UILabel()
        let combinedString = NSMutableAttributedString()
        combinedString.append(condition)
        combinedString.append(verb)
        label.attributedText = combinedString
        return label
    }()
    
    lazy var stackView: UIStackView = {
       let stview = UIStackView(arrangedSubviews: [yesterdayLabel, compareLabel, weatherLabel])
        stview.spacing = 0
        stview.axis = .vertical
        stview.alignment = .leading
        stview.distribution = .fillEqually
        return stview
    }()
    
    var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "23"
        label.font = .systemFont(ofSize: 150, weight: .heavy)
        return label
    }()
    
    var unitLabel: UILabel = {
        let label = UILabel()
        label.text = "º"
        label.font = .systemFont(ofSize: 150, weight: .heavy)
        return label
    }()
    
    var scrollAnimation: UIImage = {
        let image = UIImage()
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        setupAutoLayout()
        print(homeViewModel.userLocationString)
    }

    func setupNaviBar() {
        title = "서울시 강남구 역삼동"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        addButton.tintColor = .black
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        print(#function)
    }
    
    func setupAutoLayout() {
        view.addSubview(weatherIcon)
        weatherIcon.snp.makeConstraints {
            $0.top.equalToSuperview().offset(136)
            $0.leading.equalToSuperview().offset(24)
            $0.width.height.equalTo(100)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(weatherIcon.snp.bottom).offset(42)
            $0.leading.equalToSuperview().offset(24)
        }
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(493)
            $0.leading.equalToSuperview().offset(70.5)
        }
        
        view.addSubview(unitLabel)
        unitLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(497)
            $0.leading.equalTo(temperatureLabel.snp.trailing).offset(4)
        }
        
        view.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(144)
            $0.trailing.equalToSuperview().inset(27)
            $0.width.height.equalTo(30)
        }
        
        view.addSubview(notificationButton)
        notificationButton.snp.makeConstraints {
            $0.top.equalTo(bookmarkButton.snp.bottom).offset(13.5)
            $0.trailing.equalToSuperview().inset(27)
            $0.width.height.equalTo(30)
        }
    }
    
    @objc func bookmarkButtonTapped() {
        print(#function)
    }
    
    @objc func notificationButtonTapped() {
        print(#function)
    }
    
}
