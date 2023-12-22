import SnapKit
import UIKit

// this class sets details for every cell
class MyTableViewCell: UITableViewCell {
    // every cell contains zone for full name of currency and place for mark image (marked circle or empty circle)
    var fullName = UILabel(frame: .zero)
    var checkmImage  = UIImageView()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // styling setting of full name zone in cell
        fullName.textAlignment = .left
        fullName.numberOfLines = 0
        fullName.backgroundColor = .black
        fullName.textColor = .white
        
        // adding of objects to every cell
        contentView.addSubview(fullName)
        contentView.addSubview(checkmImage)

        // CONSTRAINTS for cell objects
        fullName.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
        }

        checkmImage.snp.makeConstraints { make in
            make.trailing.centerY.equalToSuperview()
        }
    }
    
    // this function is needed to define what pictures will be downloaded according to comparance with "chosenRow" at the screen "CurrencyScreen"
    func setup(text: String, isChecked: Bool) {
        fullName.text = text
        checkmImage.image = isChecked ? .init(named: "Ellipse59") : .init(named: "Ellipse61")
    }

    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
