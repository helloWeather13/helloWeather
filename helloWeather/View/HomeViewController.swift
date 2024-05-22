//
//  HomeViewController.swift
//  helloWeather
//
//  Created by Sam.Lee on 5/13/24.
//

import UIKit
import SnapKit
import SkeletonView

class HomeViewController: UIViewController {
    
    var homeViewModel = HomeViewModel()
    var bookmarkButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var notificationButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFit
        button.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .clear
        button.addTarget(self, action: #selector(notificationButtonTapped), for: .touchUpInside)
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
    var emptyView1 = UIView()
    var emptyView2 = UIView()
    var emptyView3 = UIView()
    var emptyView4 = UIView()
    var emptyView5 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationCenter()
        setupNaviBar()
        setupSecondLabel()
        setupThirdLabel()
        setupAutoLayout()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       if let existingAlertView = view.subviews.first(where: { $0.tag == 999 }) {
            existingAlertView.removeFromSuperview()
        }
        emptyView5.isHidden = false
        [view,emptyView1,emptyView2,emptyView3,emptyView4,emptyView5].forEach{
            $0?.showAnimatedSkeleton()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
            [self.view,self.emptyView1,self.emptyView2,self.emptyView3,self.emptyView4,self.emptyView5].forEach{
                $0?.hideSkeleton(transition: .crossDissolve(0.25))
                
            }
            self.emptyView5.isHidden = true
        })
       
    }
    override func viewDidDisappear(_ animated: Bool) {
        emptyView5.isHidden = true
        [view,emptyView1,emptyView2,emptyView3,emptyView4,emptyView5].forEach{
            $0?.showAnimatedSkeleton()
        }
    }
    func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(dataRecevied(notification:)), name: NSNotification.Name("SwitchTabNotification"), object: nil)
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
        let searchVC = SearchViewController()
        searchVC.delegate = self
        self.navigationController?.pushViewController(searchVC, animated: false)
        
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
        view.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(124)
            $0.trailing.equalToSuperview().inset(32)
            $0.width.height.equalTo(24)
        }
        notificationButton.snp.makeConstraints {
            $0.centerY.equalTo(bookmarkButton)
            $0.leading.equalTo(bookmarkButton.snp.leading)
            $0.width.height.equalTo(24)
        }
        
        [emptyView1, emptyView2, emptyView3,emptyView4, emptyView5].forEach{
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        emptyView1.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(stackView.snp.top)
            $0.width.equalTo(100)
            $0.height.equalTo(42)
        }
        emptyView2.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(emptyView1.snp.bottom).offset(2)
            $0.width.equalTo(300)
            $0.height.equalTo(42)
        }
        emptyView3.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(30)
            $0.top.equalTo(emptyView2.snp.bottom).offset(2)
            $0.width.equalTo(300)
            $0.height.equalTo(42)
        }
        emptyView4.snp.makeConstraints{
            $0.width.equalTo(220)
            $0.height.equalTo(120)
            $0.trailing.equalToSuperview().offset(-30)
            $0.top.equalTo(stackView.snp.bottom).offset(108)
        }
        emptyView5.snp.makeConstraints{
            $0.centerY.centerX.equalTo(bookmarkButton)
            $0.width.height.equalTo(40)
        }
        [view,emptyView1,emptyView2,emptyView3,emptyView4,emptyView5].forEach{
            $0?.isSkeletonable = true
            $0?.skeletonCornerRadius = 20
        }
        
        
    }
    
    func bind(){
        self.homeViewModel.bookMarkDidChanged = { isBookmarked in
            if isBookmarked {
                self.bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            }else{
                self.bookmarkButton.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
            }
            self.bookmarkButton.superview?.layoutIfNeeded()
        }
        self.homeViewModel.notfiedDiDChanged = { isnotified in
            if isnotified {
                self.notificationButton.setBackgroundImage(UIImage(systemName: "bell.fill"), for: .normal)
            }else{
                self.notificationButton.setBackgroundImage(UIImage(systemName: "bell"), for: .normal)
            }
            self.notificationButton.superview?.layoutIfNeeded()
        }
    }
    @objc func bookmarkButtonTapped() {
        
        if !homeViewModel.isBookmarked {
            homeViewModel.isBookmarked = true
            
            let bookMarkImage = UIImageView()
            bookMarkImage.image = .popupBookmark
            showCustomAlert(image: bookMarkImage.image!, message: "북마크 페이지에 추가했어요.")
            UIView.animate(withDuration: 0.3, animations: {
                self.notificationButton.tintColor = .black
                self.notificationButton.snp.updateConstraints {
                    $0.leading.equalTo(self.bookmarkButton.snp.leading).offset(-32)
                }
//                self.view.layoutIfNeeded()
            })
            self.homeViewModel.saveCurrentBookMark()
        } else {
            homeViewModel.isBookmarked = false
            let bookMarkImage = UIImageView()
            bookMarkImage.image = .popupBookmark1
            showCustomAlert(image: bookMarkImage.image!, message: "북마크 페이지에서 삭제했어요.")
            UIView.animate(withDuration: 0.3, animations: {
                self.notificationButton.tintColor = .clear
            }) { _ in
                self.notificationButton.snp.updateConstraints {
                    $0.leading.equalTo(self.bookmarkButton).offset(0)
                }
                UIView.animate(withDuration: 0.3) {
                    self.view.layoutIfNeeded()
                }
            }
            self.homeViewModel.deleteCurrentBookMark()
        }
    }
    
    @objc func notificationButtonTapped() {
        self.homeViewModel.changeNotiCurrentBookMark()
        if !homeViewModel.isNotified {
            
            let alarmImageYellow = UIImageView()
            alarmImageYellow.image = .popupNotification1
            homeViewModel.isNotified = false
            showCustomAlert(image: alarmImageYellow.image!, message: "비소식 알림을 껐어요.")
        }
        else {
            
            let alarmImageYellow = UIImageView()
            alarmImageYellow.image = .popupNotification
            homeViewModel.isNotified = true
            showCustomAlert(image: alarmImageYellow.image!, message: "비소식 1시간 전에 알림을 울려요.")
        }
    }
    
    @objc func dataRecevied(notification: Notification){
        guard let newSearchModel = notification.object as? SearchModel else{
            return
        }
        self.homeViewModel.currentSearchModel = newSearchModel
        createBackButton()
    }
    func createBackButton(){
        let backButton = UIView()
        backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        backButton.isUserInteractionEnabled = true // Enable user interaction

        // Create the label for the button
        let backImage = UIImageView()
        backImage.image = UIImage(named: "chevron-left")
        
        backButton.addSubview(backImage)
        // Add constraints to the label
        backImage.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        // Add a tap gesture recognizer to the deleteButton
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTap))
        backButton.addGestureRecognizer(tapGesture)

        // Create the UIBarButtonItem with the custom view
        let barButton = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = barButton
    }
}

extension HomeViewController : TransferDataToMainDelegate {
    func searchDidTouched(searchModel: SearchModel) {
        self.homeViewModel.currentSearchModel = searchModel
        createBackButton()
    }
    
    @objc func backButtonTap(){
        self.homeViewModel.getUserLocation()
        self.navigationItem.leftBarButtonItem?.isHidden = true
    }
}

