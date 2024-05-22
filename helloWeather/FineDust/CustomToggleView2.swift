import UIKit
import SnapKit

class CustomToggleView2: UIView {
    private let viewModel: WeatherDetailViewModel
    private var isOn: Bool = false {
        didSet {
            updateToggleState()
            viewModel.changeToggle()
        }
    }
    
    private let backgroundRectangle = UIView()
    private let toggleRectangle = UIView()
    private let leftLabel = UILabel()
    private let rightLabel = UILabel()
    
    private var toggleLeadingConstraint: Constraint?
    private var toggleTrailingConstraint: Constraint?
    
    init(viewModel: WeatherDetailViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundRectangle.backgroundColor = UIColor.gray.withAlphaComponent(0.4)
        backgroundRectangle.layer.cornerRadius = 10
        addSubview(backgroundRectangle)
        
        toggleRectangle.backgroundColor = .white
        toggleRectangle.layer.cornerRadius = 6
        addSubview(toggleRectangle)
        
        leftLabel.text = "미세"
        leftLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        addSubview(leftLabel)
        
        rightLabel.text = "초미세"
        rightLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        addSubview(rightLabel)
        
        backgroundRectangle.snp.makeConstraints { make in
            make.width.equalTo(90)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        toggleRectangle.snp.makeConstraints { make in
            make.width.equalTo(42)
            make.height.equalTo(24)
            make.centerY.equalTo(backgroundRectangle)
            self.toggleLeadingConstraint = make.leading.equalTo(backgroundRectangle).offset(4).constraint
        }
        
        leftLabel.snp.makeConstraints { make in
            make.leading.equalTo(backgroundRectangle).offset(14)
            make.centerY.equalTo(backgroundRectangle)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundRectangle).offset(-8)
            make.centerY.equalTo(backgroundRectangle)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSwitch))
        addGestureRecognizer(tapGesture)
        
        updateToggleState()
    }
    
    @objc private func toggleSwitch() {
        isOn.toggle()
    }
    
    private func updateToggleState() {
        UIView.animate(withDuration: 0.1) {
            if self.isOn {
                self.toggleLeadingConstraint?.update(offset: self.backgroundRectangle.frame.width - self.toggleRectangle.frame.width - 4)
            } else {
                self.toggleLeadingConstraint?.update(offset: 4)
            }
            self.leftLabel.textColor = self.isOn ? .white : .black
            self.rightLabel.textColor = self.isOn ? .black : .white
            self.layoutIfNeeded()
        }
    }
}
