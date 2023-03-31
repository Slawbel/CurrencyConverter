import Foundation
import UIKit
import Swiftstraints

struct RateAndData {
    let dateRate: String
    let curRate: String
}

class MyTableViewCell1: UITableViewCell {
    private let dateLabel = UILabel(frame: .zero)
    private let curLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dateLabel.textAlignment = .center
        curLabel.textAlignment = .center
        contentView.addSubview(dateLabel)
        contentView.addSubview(curLabel)
        dateLabel.numberOfLines = 0
        curLabel.numberOfLines = 0
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelLeadingConstraint: NSLayoutConstraint = dateLabel.leadingAnchor == contentView.leadingAnchor
        let labelTrailingConstraint: NSLayoutConstraint = dateLabel.trailingAnchor == contentView.trailingAnchor
        let labelTopConstraint: NSLayoutConstraint = dateLabel.topAnchor == contentView.topAnchor
        let labelBottomConstraint: NSLayoutConstraint = curLabel.topAnchor == dateLabel.bottomAnchor
        
        curLabel.translatesAutoresizingMaskIntoConstraints = false
        let curLabelLeadingConstraint: NSLayoutConstraint = curLabel.leadingAnchor == contentView.leadingAnchor
        let curLabelTrailingConstraint: NSLayoutConstraint = curLabel.trailingAnchor == contentView.trailingAnchor
        let curLabelBottomConstraint: NSLayoutConstraint = curLabel.bottomAnchor == contentView.bottomAnchor
        
        NSLayoutConstraint.activate([labelTopConstraint, labelBottomConstraint, labelLeadingConstraint, labelTrailingConstraint])
        NSLayoutConstraint.activate([curLabelLeadingConstraint, curLabelTrailingConstraint, curLabelBottomConstraint])
        
        
    }
    
    func setData(dates: RateAndData) {
        dateLabel.text = dates.dateRate
        curLabel.text = dates.curRate
        
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

