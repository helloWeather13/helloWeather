import UIKit
import SnapKit
import RxSwift

class SectionHeaderView : UITableViewHeaderFooterView{
    let titleLabel = UILabel()
    let button = UIButton()
    var disposeBag = DisposeBag()
    
    static let identifier = "SectionHeaderView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        
    }
    deinit{
        disposeBag = DisposeBag()
    }
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }

    func configure(section: Int, state: SearchState){ 
        [button, titleLabel].forEach{
            contentView.addSubview($0)
        }
        switch state{
        case .beforeSearch:
            titleLabel.text = "최근 검색"
            titleLabel.snp.makeConstraints{ make in
                make.top.equalToSuperview()
                make.leading.equalToSuperview()
                make.height.equalTo(32)
            }
            button.setTitle("지우기", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitleColor(.secondaryLabel, for: .normal)
            button.tintColor = .systemGray
            button.snp.makeConstraints{
                $0.centerY.equalTo(titleLabel)
                $0.trailing.equalToSuperview().offset(-10)
                $0.leading.equalTo(titleLabel).priority(999)
                $0.width.equalTo(40)
                $0.height.equalTo(32)
            }

        case .searching:
            titleLabel.text = "연관 검색어"
            
            titleLabel.snp.makeConstraints{ make in
                make.top.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(32)
            }
        }
        titleLabel.font = .boldSystemFont(ofSize: 20)
    }
    func configureFooter(section: Int){
        if section == 1{
            titleLabel.text = "결과 끝!"
            titleLabel.font = .systemFont(ofSize: 17)
            titleLabel.textAlignment = .center
        }
    }
    
}
