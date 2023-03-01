import SnapKit
import UIKit

class MyTableViewCell: UITableViewCell {
    var fullName = UILabel(frame: .zero)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fullName.textAlignment = .center
        contentView.addSubview(fullName)
        fullName.numberOfLines = 0
    

        fullName.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }

    func setup(text: String) {
        fullName.text = text
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
