import UIKit
import Charts
import SnapKit

class DiagramResult: UIViewController, ChartViewDelegate {
    
    private let diagramStackView = UIStackView()
    
    lazy var lineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        return chartView
    }()
    
    private let labelDiagram = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    var chosenCurShortNameBase: String?
    var chosenCurShortName1: String?
    var chosenCurShortName2: String?
    var chosenCurShortName3: String?
    
    private let currencyNameLabel1 = UILabel()
    private let currencyNameLabel2 = UILabel()
    private let currencyNameLabel3 = UILabel()
    
    private var rateData: RateData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")
        
        diagramStackView.axis = .vertical
        diagramStackView.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#181B20")
        diagramStackView.layer.cornerRadius = 30
        
        lineChartView.backgroundColor = .clear
        lineChartView.leftAxis.axisLineColor = .white
        lineChartView.leftAxis.labelTextColor = .white
        lineChartView.rightAxis.axisLineColor = .clear
        lineChartView.rightAxis.labelTextColor = .clear
        lineChartView.xAxis.axisLineColor = .white
        lineChartView.xAxis.labelTextColor = .white
        lineChartView.xAxis.labelPosition = .bottom
        
        labelDiagram.backgroundColor = .clear
        labelDiagram.textAlignment = .center
        labelDiagram.textColor = .white
        labelDiagram.text = NSLocalizedString("labelDiagram", comment: "")
        labelDiagram.font = labelDiagram.font.withSize(24)
        
        
        startDatePicker.timeZone = NSTimeZone.local
        startDatePicker.datePickerMode = .date
        startDatePicker.overrideUserInterfaceStyle = .dark
        startDatePicker.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        startDatePicker.setDate(.now, animated: true)
        startDatePicker.layerCornerRadius = 15
        startDatePicker.setValue(UIColor.white, forKey: "textColor")
        startDatePicker.addTarget(self, action: #selector(rangeOfDates), for: .valueChanged)
        startDatePicker.addTarget(self, action: #selector(self.curHistory), for: .valueChanged)
        
        endDatePicker.timeZone = NSTimeZone.local
        endDatePicker.datePickerMode = .date
        endDatePicker.overrideUserInterfaceStyle = .dark
        endDatePicker.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        endDatePicker.setDate(.now, animated: true)
        endDatePicker.layerCornerRadius = 15
        endDatePicker.setValue(UIColor.white, forKey: "textColor")
        endDatePicker.addTarget(self, action: #selector(rangeOfDates), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(self.curHistory), for: .valueChanged)
        
        currencyNameLabel1.layerCornerRadius = 10
        currencyNameLabel1.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        
        currencyNameLabel2.layerCornerRadius = 10
        currencyNameLabel2.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        
        currencyNameLabel3.layerCornerRadius = 10
        currencyNameLabel3.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        
        
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: rangeOfDates())
    
        
        
        view.addSubview(diagramStackView)
        diagramStackView.addSubview(lineChartView)
        view.addSubview(labelDiagram)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        
        view.addSubview(currencyNameLabel1)
        view.addSubview(currencyNameLabel2)
        view.addSubview(currencyNameLabel3)
        
        diagramStackView.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(14)
            make.top.equalTo(view).inset(164)
            make.height.equalTo(590)
            make.width.equalTo(360)
        }
        
        lineChartView.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(28)
            make.top.equalTo(view).inset(190)
            make.height.equalTo(540)
        }
        
        labelDiagram.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(148)
            make.top.equalTo(view).inset(58)
            make.height.equalTo(40)
            make.width.equalTo(95)
        }
        
        startDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(19)
            make.width.equalTo(128)
            make.height.equalTo(35)
            make.top.equalTo(view).inset(115)
        }
        
        endDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(154)
            make.width.equalTo(128)
            make.height.equalTo(35)
            make.top.equalTo(view).inset(115)
        }
        
        currencyNameLabel1.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(14)
            make.width.equalTo(114)
            make.height.equalTo(28)
            make.top.equalTo(view).inset(768)
        }
        
        currencyNameLabel2.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(137)
            make.width.equalTo(114)
            make.height.equalTo(28)
            make.top.equalTo(view).inset(768)
        }
        
        currencyNameLabel3.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(260)
            make.width.equalTo(114)
            make.height.equalTo(28)
            make.top.equalTo(view).inset(768)
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

    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    // setting lines on diagram according to each currency
    func setData(coordinates: [ChartDataEntry], coordinates2 : [ChartDataEntry], coordinates3: [ChartDataEntry], chosenCur1: String, chosenCur2: String, chosenCur3: String) {
        let set1 = LineChartDataSet(entries: coordinates, label: chosenCur1)
        let set2 = LineChartDataSet(entries: coordinates2, label: chosenCur2)
        let set3 = LineChartDataSet(entries: coordinates3, label: chosenCur3)
        set1.colors = [NSUIColor.blue]
        set2.colors = [NSUIColor.red]
        set3.colors = [NSUIColor.orange]
        let data = LineChartData(dataSets: [set1, set2, set3])
        lineChartView.data = data
    }
    
    
    @objc func rangeOfDates() -> [String] {
        var arrayOfDates: [String] = []
        let dayDurationInSeconds: TimeInterval = 60*60*24
        for date in stride(from: startDatePicker.date, to: endDatePicker.date, by: dayDurationInSeconds) {
            let tempStringDate = changeDateFormat(dateForChange: date)
            arrayOfDates.append(tempStringDate)
        }
        print(arrayOfDates)
        return arrayOfDates
    }
    
    func changeDateFormat (dateForChange: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: dateForChange)
        return stringDate
    }
    
    @objc func curHistory() {
        guard let chosenCurShortNameBase = chosenCurShortNameBase else {
            let alertMissedCurBase = UIAlertController(title: "Missing based currency", message: "Please, select based currency", preferredStyle: .alert)
            let okActionBase = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertMissedCurBase.addAction(okActionBase)
            present(alertMissedCurBase, animated:  true, completion: nil)
            return
        }
        
        
        // making string with all currencies for API request
        var symbols = ""
        if let chosenCurShortName1 = chosenCurShortName1 {
            symbols += chosenCurShortName1
        } else {
            let alertMissedCur1 = UIAlertController(title: "Missing currency 1", message: "Please, select currency #1", preferredStyle: .alert)
            let okAction1 = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertMissedCur1.addAction(okAction1)
            present(alertMissedCur1, animated:  true, completion: nil)
            return
        }
        if let chosenCurShortName2 = chosenCurShortName2 {
            if symbols != "" {
                symbols += ","
            }
            symbols += chosenCurShortName2
        }
        if let chosenCurShortName3 = chosenCurShortName3 {
            if symbols != "" {
                symbols += ","
            }
            symbols += chosenCurShortName3
        }
        
        
        // api request for all rates during some period
        let stringUrl = "https://api.apilayer.com/fixer/timeseries?start_date=" + (startChosenDates) + "&end_date=" + (endChosenDates) + "&symbols=" + symbols + "&base=" + (chosenCurShortNameBase)
        
        guard let url = URL(string: stringUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("mUGIIf6VCrvec8zDdJv2EofmA4euGt2z", forHTTPHeaderField: "apikey")
        
        guard let data = try? URLSession.shared.dataSync(with: request).0 else {
            return
        }
        //print(String(data: data, encoding: .utf8)!)
        rateData = RateData(from: data)
        
        self.setData(coordinates: coordinates(), coordinates2: coordinates2(), coordinates3: coordinates3(), chosenCur1: chosenCurShortName1 ?? "", chosenCur2: chosenCurShortName2 ?? "", chosenCur3: chosenCurShortName3 ?? "")
    }
        
    func coordinates() -> [ChartDataEntry] {

        guard let chosenCurShortName1 = chosenCurShortName1 else {
            return []
        }
        var x = -1
        let diagramData = (rateData?.rates.sorted(by: { dateAndRateLeft, dateAndRateRight in
            return dateAndRateLeft.key < dateAndRateRight.key
        }).compactMap { key, value in
            guard let currency = value[chosenCurShortName1] else {
                return nil as ChartDataEntry?
            }
            x += 1
            return ChartDataEntry(x: Double(x), y: currency)
        })
        return diagramData ?? []
    }
    
    func coordinates2() -> [ChartDataEntry] {
        guard let chosenCurShortName2 = chosenCurShortName2 else {
            return []
        }
        var y = -1
        let diagramData2 = (rateData?.rates.sorted(by: { dateAndRateLeft, dateAndRateRight in
            return dateAndRateLeft.key < dateAndRateRight.key
        }).compactMap { key, value in
            guard let currency2 = value[chosenCurShortName2] else {
                return nil as ChartDataEntry?
            }
            y += 1
            return ChartDataEntry(x: Double(y), y: currency2)
        })
        return diagramData2 ?? []
    }
    
    func coordinates3() -> [ChartDataEntry] {
        guard let chosenCurShortName3 = chosenCurShortName3 else {
            return []
        }
        var z = -1
        let diagramData3 = (rateData?.rates.sorted(by: { dateAndRateLeft, dateAndRateRight in
            return dateAndRateLeft.key < dateAndRateRight.key
        }).compactMap { key, value in
            guard let currency3 = value[chosenCurShortName3] else {
                return nil as ChartDataEntry?
            }
            z += 1
            return ChartDataEntry(x: Double(z), y: currency3)
        })
        return diagramData3 ?? []
    }
    
    
}

/*extension Date {
    var iso8601: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date
    }
}*/




