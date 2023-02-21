import SnapKit
import UIKit

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
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(fullName.snp.top)
        }

        fullName.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}