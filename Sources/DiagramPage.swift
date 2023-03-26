import UIKit
import SnapKit
import SwifterSwift

class DiagramPage: UIViewController {
    private let labelChooseTime = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    private var rates = [(String, Double)]()
    
    
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
        
        
        
        view.addSubview(labelChooseTime)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
       
        
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
        print("Nothing")
        let currencyScr = ConverterScreen()
        guard (currencyScr.chosenCurShortName1 != nil) && (currencyScr.chosenCurShortName2 != nil) else {
            return
        }
        
        let stringUrl = "https://api.apilayer.com/fixer/timeseries?start_date=" + (startChosenDates) + "&end_date=" + (endChosenDates) + "&to=" + (currencyScr.chosenCurShortName2) + "&from=" + (currencyScr.chosenCurShortName1)
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
        
        guard let rateData = RateData(from: data) else {
            return
        }
        
        print(rateData)
        
        //rates = rateData.rates.map { $0 }
        
        //label.text = rates.map {$1} as? String
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        curHistory()
    }    
}
