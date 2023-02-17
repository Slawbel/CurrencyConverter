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
            make.leading.equalTo(contentView.leadingAnchor as! ConstraintRelatableTarget)
            make.trailing.equalTo(contentView.trailingAnchor as! ConstraintRelatableTarget)
            make.top.equalTo(contentView.topAnchor as! ConstraintRelatableTarget)
            make.bottom.equalTo(fullName.topAnchor as! ConstraintRelatableTarget)
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
    


class CurrencyScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .init(x: 20, y: 20, width: 350, height: 804), style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.addSubview(tableView)
    }

    
    
    
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        40
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
            
    }
        
    
    
}
        
        
