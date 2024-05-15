import UIKit
import SnapKit

class SectionHeaderView : UITableViewHeaderFooterView{
    let titleLabel = UILabel()
    let button = UIButton()
    static let identifier = "SectionHeaderView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        
    }
    
    required init?(coder : NSCoder){
        fatalError("init(Coder:) has not been implemented")
    }

    func configure(section: Int, state: State){
        contentView.backgroundColor = .red
        [button, titleLabel].forEach{
            contentView.addSubview($0)
        }
        switch state{
        case .beforeSearch:
            titleLabel.text = "최근 검색"
            titleLabel.snp.makeConstraints{ make in
                make.top.bottom.equalToSuperview()
                make.leading.equalToSuperview().offset(5)
            }
            button.setTitle("지우기", for: .normal)
            button.backgroundColor = .blue
            button.snp.makeConstraints{
                $0.top.bottom.equalToSuperview()
                $0.trailing.equalToSuperview().offset(-10)
                $0.leading.equalTo(titleLabel).priority(999)
                $0.width.equalTo(300)
            }
            
        case .searching:
            titleLabel.text = "연관 검색어"
            titleLabel.snp.makeConstraints{ make in
                make.top.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview().offset(10)
            }
        }
        titleLabel.font = .boldSystemFont(ofSize: 22)
    }
    func configureFooter(section: Int){
        if section == 1{
            titleLabel.text = "결과 끝!"
            titleLabel.font = .systemFont(ofSize: 17)
            titleLabel.textAlignment = .center
        }
    }
    
}
