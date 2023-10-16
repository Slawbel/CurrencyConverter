import SnapKit
import UIKit

class MyTableViewCell: UITableViewCell {
    var fullName = UILabel(frame: .zero)
    var checkmImage  = UIImageView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        fullName.textAlignment = .left
        fullName.numberOfLines = 0
        fullName.backgroundColor = .black
        fullName.textColor = .white

        contentView.addSubview(fullName)
        contentView.addSubview(checkmImage)

        fullName.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }

        checkmImage.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
    
    func setup(text: String, isChecked: Bool) {
        fullName.text = text
        checkmImage.image = isChecked ? .init(named: "Ellipse59") : .init(named: "Ellipse61")
    }

    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
