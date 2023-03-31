import UIKit
import SnapKit
import SwifterSwift

class DiagramPage: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let labelChooseTime = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private let tableView = UITableView()
    private var rates = [(String, Double)]()
    
    var short1: String!
    var short2: String!
    let rate: [String: Double] = [:]
    var rateData: Dictionary<String,[String: Double]> = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        
        labelChooseTime.backgroundColor = .white
        labelChooseTime.textAlignment = .center
        labelChooseTime.text = NSLocalizedString("chooseStartAndEndDates", comment: "")
        
        startDatePicker.timeZone = NSTimeZone.local
        startDatePicker.backgroundColor = UIColor.white
        startDatePicker.datePickerMode = .date
        startDatePicker.addTarget(self, action: #selector(ConverterScreen.datePickerValueChanged(_:)), for: .valueChanged)
        
        endDatePicker.timeZone = NSTimeZone.local
        endDatePicker.backgroundColor = UIColor.white
        endDatePicker.datePickerMode = .date
        endDatePicker.addTarget(self, action: #selector(ConverterScreen.datePickerValueChanged(_:)), for: .valueChanged)
        
        tableView.register(cellWithClass: MyTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(labelChooseTime)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(tableView)
       
        
        labelChooseTime.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(50)
            make.top.equalTo(view).inset(80)
            make.height.equalTo(50)
        }
        
        startDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(50)
            make.width.equalTo(130)
            make.height.equalTo(50)
            make.top.equalTo(view).inset(150)
        }
        
        endDatePicker.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(50)
            make.width.equalTo(130)
            make.height.equalTo(50)
            make.top.equalTo(view).inset(150)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(220)
            make.bottom.equalTo(view).inset(50)
            make.leading.trailing.equalTo(view).inset(50)
        }
        

    }
    
    private var startChosenDates: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: startDatePicker.date)
    }
    
    private var endChosenDates: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: endDatePicker.date)
    }
    
    func curHistory() {
        let stringUrl = "https://api.apilayer.com/fixer/timeseries?start_date=" + (startChosenDates) + "&end_date=" + (endChosenDates) + "&symbols=" + (short2) + "&base=" + (short1)
        guard let url = URL(string: stringUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("mUGIIf6VCrvec8zDdJv2EofmA4euGt2z", forHTTPHeaderField: "apikey")
        
        guard let data = try? URLSession.shared.dataSync(with: request).0 else {
            return
        }
        print(String(data: data, encoding: .utf8)!)
        
        /*if rateData = RateData(from: data) {
            for _ in 0...rateData.rates.count-1 {
                self.rates = rateData.rates.map { $1 }
            }
        } else {
            return
        }*/
        
        
        
        
        //rates = rateData.rates.map { $1 }
        //label.text = rates.map {$1} as? String
    }
    
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell1", for: indexPath) as? MyTableViewCell1
        //cell?.setData(dates: rateData[indexPath.row]?.keys ?? "")
        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        rateData.count
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        curHistory()
    }    
}
