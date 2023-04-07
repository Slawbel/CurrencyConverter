import Foundation
import UIKit
import Swiftstraints

struct RateAndData {
    let dateRate: String
    let curRate: String
}

class RatesHistoryList: UITableViewCell {
    private let dateLabel = UILabel(frame: .zero)
    private let rateLabel = UILabel(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        dateLabel.textAlignment = .left
        rateLabel.textAlignment = .right
        contentView.addSubview(dateLabel)
        contentView.addSubview(rateLabel)
        dateLabel.numberOfLines = 0
        rateLabel.numberOfLines = 0
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let labelLeadingConstraint: NSLayoutConstraint = dateLabel.leadingAnchor == contentView.leadingAnchor
        let labelTrailingConstraint: NSLayoutConstraint = dateLabel.trailingAnchor == contentView.trailingAnchor
        let labelTopConstraint: NSLayoutConstraint = dateLabel.topAnchor == contentView.topAnchor
        let labelBottomConstraint: NSLayoutConstraint = rateLabel.topAnchor == dateLabel.bottomAnchor
        
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        let curLabelLeadingConstraint: NSLayoutConstraint = rateLabel.leadingAnchor == contentView.leadingAnchor
        let curLabelTrailingConstraint: NSLayoutConstraint = rateLabel.trailingAnchor == contentView.trailingAnchor
        let curLabelBottomConstraint: NSLayoutConstraint = rateLabel.bottomAnchor == contentView.bottomAnchor
        
        NSLayoutConstraint.activate([labelTopConstraint, labelBottomConstraint, labelLeadingConstraint, labelTrailingConstraint])
        NSLayoutConstraint.activate([curLabelLeadingConstraint, curLabelTrailingConstraint, curLabelBottomConstraint])
        
        
    }
    
    func setData(dates: RateAndData) {
        dateLabel.text = dates.dateRate
        rateLabel.text = dates.curRate
        
    }
    
    func set(date: String) {
        dateLabel.text = date
    }
    
    func setRate(rateValue: String!) {
        rateLabel.text = rateValue
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

