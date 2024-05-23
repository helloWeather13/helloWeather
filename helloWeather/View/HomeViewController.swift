import UIKit
import SnapKit
import SkeletonView
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
        label.font = UIFont(name: "Pretendard-Regular", size: 14)
        label.textColor = #colorLiteral(red: 0.3960784078, green: 0.3960784078, blue: 0.3960784078, alpha: 1)
        return label
    }()
    
    lazy var updateStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [rssIcon, lastUpdateLabel])
        stview.axis = .horizontal
        stview.spacing = 4
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
        stview.spacing = 0
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
        label.font = UIFont(name: "Nunito-Black", size: 136)
        label.addCharacterSpacing()
        return label
    }()
    
    var unitLabel: UILabel = {
        let label = UILabel()
        label.text = "°"
        label.font = UIFont(name: "Nunito-Black", size: 136)
        return label
    }()
    
    lazy var tempStackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [temperatureLabel, unitLabel])
        stview.alignment = .fill
        stview.axis = .horizontal
        stview.spacing = 6
        stview.distribution = .fill
        return stview
    }()
    
    var scrollAnimation: LottieAnimationView = {
        let lottie = LottieAnimationView(name: "Scroll")
        lottie.alpha = 1
        return lottie
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.988, green: 0.988, blue: 0.992, alpha: 1)
        setupNotificationCenter()
        setupNaviBar()
        setupLastUpdateLabel()
        setupSecondLabel()
        setupThirdLabel()
        setupAutoLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.homeViewModel.loadNotification()
        if let existingAlertView = view.subviews.first(where: { $0.tag == 999 }) {
            existingAlertView.removeFromSuperview()
        }
        
    }
    override func setupAlertViewConstraints(_ customAlertView: UIView, image: UIImage, messageLabel: UILabel) {
          customAlertView.snp.makeConstraints { make in
              make.bottom.equalTo(view.snp.bottom).inset(5)
            make.centerX.equalToSuperview()
            make.height.equalTo(max(image.size.height, 40))
            make.width.equalTo(image.size.width + messageLabel.intrinsicContentSize.width + 30)
          }
        }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self, selector: #selector(dataRecevied(notification:)), name: NSNotification.Name("SwitchTabNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dataReceviedCurrent(notification:)), name: NSNotification.Name("SwitchTabNotificationCurrent"), object: nil)
    }
    
    func setupLastUpdateLabel() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let formatted = dateFormatter.string(from: Date())
        lastUpdateLabel.text = "마지막 업데이트 \(formatted)"
    }
    
    func setupNaviBar() {
        
        homeViewModel.addressOnCompleted = { [unowned self] address in
            if self.homeViewModel.isCurrent {
                let titleView = UIView()
                
                let imageView = UIImageView(image: UIImage(named: "navigation"))
                imageView.contentMode = .scaleAspectFit
                
                let titleLabel: UILabel = {
                    let label = UILabel()
                    label.text = address
                    label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
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
            }else{
                
                let titleLabel: UILabel = {
                    let label = UILabel()
                    label.text = address
                    label.font = UIFont(name: "Pretendard-SemiBold", size: 18)
                    return label
                }()
                
                titleLabel.sizeToFit()
                self.navigationItem.titleView = titleLabel
            }
            
        }
        
        let searchButton = UIBarButtonItem(image: UIImage(named: "search-0"), style: .plain, target: self, action: #selector(searchButtonTapped))
        searchButton.tintColor = .black
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func searchButtonTapped() {
        let searchVC = SearchViewController()
        searchVC.delegate = self
        self.navigationController?.pushViewController(searchVC, animated: false)
        (self.navigationController?.parent as? MainViewController)?.scrollView.isScrollEnabled = false
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
            
            temperatureLabel.text = String(Int(homeViewModel.todayFeelsLike))
            temperatureLabel.addCharacterSpacing()
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(26)
            $0.leading.equalToSuperview().offset(32)
        }
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.top.equalTo(updateStackView.snp.bottom).offset(59)
            $0.leading.equalToSuperview().offset(30)
        }
        
        thermometerIcon.snp.makeConstraints {
            $0.width.height.equalTo(36)
        }
        
        weatherIcon.snp.makeConstraints {
            $0.width.height.equalTo(36)
        }
        
        view.addSubview(tempStackView)
        tempStackView.snp.makeConstraints {
            $0.bottom.equalTo(view).offset(-104)
            $0.trailing.equalToSuperview().offset(-32)
            
        }
        
        view.addSubview(bookmarkButton)
        bookmarkButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            $0.trailing.equalToSuperview().inset(34)
            $0.width.height.equalTo(24)
        }
        
        view.addSubview(notificationButton)
        notificationButton.snp.makeConstraints {
            $0.top.equalTo(bookmarkButton.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(34)
            $0.width.height.equalTo(24)
        }
        
        view.addSubview(scrollAnimation)
        scrollAnimation.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(42)
            $0.centerX.equalToSuperview()
        }
        
        scrollAnimation.loopMode = .repeat(4)
        scrollAnimation.play { _ in
            UIView.animate(withDuration: 0.5, animations: {
                self.scrollAnimation.alpha = 1
            }, completion: nil)
        }
    }
    
    func bind(){
        self.homeViewModel.bookMarkDidChanged = { isBookmarked in
            if isBookmarked {
                self.bookmarkButton.setBackgroundImage(UIImage(named: "bookmark_S-1"), for: .normal)
            } else {
                self.bookmarkButton.setBackgroundImage(UIImage(named: "bookmark_S-0"), for: .normal)
                self.notificationButton.setBackgroundImage(nil, for: .normal)
            }
            self.bookmarkButton.superview?.layoutIfNeeded()
        }
        self.homeViewModel.notfiedDiDChanged = { isnotified in
            if isnotified {
                self.notificationButton.setBackgroundImage(UIImage(named: "notification_S-1"), for: .normal)
            } else {
                self.notificationButton.setBackgroundImage(UIImage(named: "notification_S-0"), for: .normal)
            }
            self.notificationButton.superview?.layoutIfNeeded()
        }
    }
    
    @objc func bookmarkButtonTapped() {
        
        if !homeViewModel.isBookmarked {
            homeViewModel.isBookmarked = true
            bookmarkButton.setBackgroundImage(UIImage(named: "bookmark_S-1"), for: .normal)
            
            UIView.transition(with: self.notificationButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.notificationButton.setBackgroundImage(UIImage(named: "notification_S-0"), for: .normal)
            }, completion: nil)
            
            let bookMarkImage = UIImageView()
            bookMarkImage.image = .popupBookmark
            showCustomAlert(image: bookMarkImage.image!, message: "북마크 페이지에 추가했어요.")
            
            self.homeViewModel.saveCurrentBookMark()
        } else {
            homeViewModel.isBookmarked = false
            bookmarkButton.setBackgroundImage(UIImage(named: "bookmark_S-0"), for: .normal)
            
            UIView.transition(with: self.notificationButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.notificationButton.setBackgroundImage(nil, for: .normal)
            }, completion: nil)
            
            let bookMarkImage = UIImageView()
            bookMarkImage.image = .popupBookmark1
            showCustomAlert(image: bookMarkImage.image!, message: "북마크 페이지에서 삭제했어요.")
            
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
        self.homeViewModel.isCurrent = false
        self.homeViewModel.currentSearchModel = newSearchModel
        
        createBackButton()
    }
    
    @objc func dataReceviedCurrent(notification: Notification){
        guard let newSearchModel = notification.object as? SearchModel else{
            return
        }
        self.homeViewModel.isCurrent = true
        self.homeViewModel.currentSearchModel = newSearchModel
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
    func searchDidTouched(searchModel: SearchModel, isCurrent: Bool, isMain: Bool) {
        if isMain{
            self.homeViewModel.isCurrent = isCurrent
            self.homeViewModel.currentSearchModel = searchModel
            (self.navigationController?.parent as? MainViewController)?.scrollView.isScrollEnabled = true
            createBackButton()
        }
    }
    
    @objc func backButtonTap(){
        self.homeViewModel.isCurrent = true
        self.homeViewModel.getUserLocation()
        self.navigationItem.leftBarButtonItem?.isHidden = true
    }
}
