import UIKit
import SnapKit

class MyTableViewCell: UITableViewCell {
    
    private let shortName = UILabel(frame: .zero)
    private let fullName = UILabel(frame: .zero)
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        shortName.textAlignment = .center
        fullName.textAlignment = .center
        contentView.addSubview(shortName)
        contentView.addSubview(fullName)
        shortName.numberOfLines = 0
        fullName.numberOfLines = 0
        
        shortName.snp.makeConstraints { make in
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
            make.top.equalTo(contentView.snp.top)
            make.bottom.equalTo(fullName.snp.top)
        }
          
        fullName.snp.makeConstraints { make in
            make.leading.equalTo(contentView.leadingAnchor as! ConstraintRelatableTarget)
            make.trailing.equalTo(contentView.trailingAnchor as! ConstraintRelatableTarget)
            make.bottom.equalTo(contentView.bottomAnchor as! ConstraintRelatableTarget)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
