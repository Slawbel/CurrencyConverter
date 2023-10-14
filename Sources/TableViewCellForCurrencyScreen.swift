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

        checkmImage.translatesAutoresizingMaskIntoConstraints = false
        
        let viewsDict = [
                   "image" : checkmImage,
                   "fullName" : fullName,
                   ] as [String : Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[fullName]-[image]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[fullName]", options: [], metrics: nil, views: viewsDict))

        

        /*fullName.snp.makeConstraints { make in
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView).inset(50)
            make.bottom.equalTo(contentView)
        }*/
        
        
    }
    
    func setup(text: String) {
        fullName.text = text
    }

    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
