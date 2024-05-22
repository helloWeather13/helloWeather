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
        backgroundRectangle.backgroundColor = UIColor.lightGray.withAlphaComponent(0.4)
        backgroundRectangle.layer.cornerRadius = 10
        addSubview(backgroundRectangle)
        
        toggleRectangle.backgroundColor = .white
        toggleRectangle.layer.cornerRadius = 6
        addSubview(toggleRectangle)
        
        leftLabel.text = "°C"
        leftLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        leftLabel.textAlignment = .center
        addSubview(leftLabel)
        
        rightLabel.text = "°F"
        rightLabel.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        rightLabel.textAlignment = .center
        addSubview(rightLabel)
        
        backgroundRectangle.snp.makeConstraints { make in
            make.width.equalTo(54)
            make.height.equalTo(30)
            make.center.equalToSuperview()
        }
        
        toggleRectangle.snp.makeConstraints { make in
            make.width.equalTo(24)
            make.height.equalTo(24)
            make.centerY.equalTo(backgroundRectangle)
            self.toggleLeadingConstraint = make.leading.equalTo(backgroundRectangle).offset(4).constraint
        }
        
        leftLabel.snp.makeConstraints { make in
            make.leading.equalTo(backgroundRectangle).offset(8)
            make.centerY.equalTo(backgroundRectangle)
        }
        
        rightLabel.snp.makeConstraints { make in
            make.trailing.equalTo(backgroundRectangle).offset(-8.5)
            make.centerY.equalTo(backgroundRectangle)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleSwitch))
        addGestureRecognizer(tapGesture)
        
        updateToggleState()
    }
    
    @objc private func toggleSwitch() {
        isOn.toggle()
        viewModel.toggleTemperatureUnit()
    }
    
    private func updateToggleState() {
        UIView.animate(withDuration: 0.1) {
            if self.isOn {
                self.toggleLeadingConstraint?.update(offset: self.backgroundRectangle.frame.width - self.toggleRectangle.frame.width - 4)
            } else {
                self.toggleLeadingConstraint?.update(offset: 4)
            }
            self.leftLabel.textColor = self.isOn ? .gray : .black
            self.leftLabel.font = self.isOn ? .systemFont(ofSize: 13, weight: .medium) : .systemFont(ofSize: 13, weight: .bold)
            self.rightLabel.textColor = self.isOn ? .black : .gray
            self.rightLabel.font = self.isOn ? .systemFont(ofSize: 13, weight: .bold) : .systemFont(ofSize: 13, weight: .medium)
            self.layoutIfNeeded()
        }
    }
}
