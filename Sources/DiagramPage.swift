import UIKit
import SnapKit
import Charts


class DiagramPage: UIViewController {
    private let labelChooseCur = UILabel()
    
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let buttonChosenCurBase = UIButton()
    private let labelChosenCurBase = UILabel()
    
    private let buttonChosenCur1 = UIButton()
    private let labelChosenCur1 = UILabel()
    
    private let buttonChosenCur2 = UIButton()
    private let labelChosenCur2 = UILabel()
    
    private let buttonChosenCur3 = UIButton()
    private let labelChosenCur3 = UILabel()
    
    private let buttonResult = UIButton()
    private let buttonBack = UIButton()

    private var сhosenCurBase: String!
    private var сhosenCur1: String!
    private var сhosenCur2: String!
    private var сhosenCur3: String!

    var chosenCurShortNameBase: String?
    var chosenCurShortName1: String?
    var chosenCurShortName2: String?
    var chosenCurShortName3: String?
    
    var dataValues: [Double] = []

    var dataKey: [String] = []
    var rateValues1: [Double] = []
    let rateValues2: [Double] = []
    let rateValues3: [Double] = []

    
    private var rateData: RateData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")
        
        labelChooseCur.backgroundColor = .white
        labelChooseCur.textAlignment = .center
        labelChooseCur.text = NSLocalizedString("labelChooseCur", comment: "")
        
        startDatePicker.timeZone = NSTimeZone.local
        startDatePicker.backgroundColor = UIColor.white
        startDatePicker.datePickerMode = .date
        //startDatePicker.addTarget(self, action: #selector(ConverterScreen.datePickerValueChanged(_:)), for: .valueChanged)
        
        endDatePicker.timeZone = NSTimeZone.local
        endDatePicker.backgroundColor = UIColor.white
        endDatePicker.datePickerMode = .date
        //endDatePicker.addTarget(self, action: #selector(ConverterScreen.datePickerValueChanged(_:)), for: .valueChanged)
        
        buttonChosenCurBase.backgroundColor = .darkGray
        buttonChosenCurBase.setTitleColor(.white, for: .normal)
        let butChosecCurBase = NSLocalizedString("butChosenCurBase", comment: "")
        buttonChosenCurBase.setTitle(butChosecCurBase, for: .normal)
        buttonChosenCurBase.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelected1 = { [weak self] shortName in
                self?.сhosenCurBase = shortName
                self?.labelChosenCurBase.text = shortName
            }
            currencyScreen.onCurrencySelectedShort1 = { [weak self] longName in
                self?.chosenCurShortNameBase = longName
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.present(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        
        labelChosenCurBase.backgroundColor = .white
        labelChosenCurBase.textAlignment = .center
        
        buttonChosenCur1.backgroundColor = .darkGray
        buttonChosenCur1.setTitleColor(.white, for: .normal)
        let butChosecCur1 = NSLocalizedString("butChosenCur1", comment: "")
        buttonChosenCur1.setTitle(butChosecCur1, for: .normal)
        buttonChosenCur1.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelected2 = { [weak self] shortName in
                self?.сhosenCur1 = shortName
                self?.labelChosenCur1.text = shortName
            }
            currencyScreen.onCurrencySelectedShort2 = { [weak self] longName in
                self?.chosenCurShortName1 = longName
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.present(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        
        labelChosenCur1.backgroundColor = .white
        labelChosenCur1.textAlignment = .center
        
        buttonChosenCur2.backgroundColor = .darkGray
        buttonChosenCur2.setTitleColor(.white, for: .normal)
        let butChosecCur2 = NSLocalizedString("butChosenCur2", comment: "")
        buttonChosenCur2.setTitle(butChosecCur2, for: .normal)
        buttonChosenCur2.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelected3 = { [weak self] shortName in
                self?.сhosenCur2 = shortName
                self?.labelChosenCur2.text = shortName
            }
            currencyScreen.onCurrencySelectedShort3 = { [weak self] longName in
                self?.chosenCurShortName2 = longName
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.present(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        
        labelChosenCur2.backgroundColor = .white
        labelChosenCur2.textAlignment = .center
        
        buttonChosenCur3.backgroundColor = .darkGray
        buttonChosenCur3.setTitleColor(.white, for: .normal)
        let butChosecCur3 = NSLocalizedString("butChosenCur3", comment: "")
        buttonChosenCur3.setTitle(butChosecCur3, for: .normal)
        buttonChosenCur3.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelected4 = { [weak self] shortName in
                self?.сhosenCur3 = shortName
                self?.labelChosenCur3.text = shortName
            }
            currencyScreen.onCurrencySelectedShort4 = { [weak self] longName in
                self?.chosenCurShortName3 = longName
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.present(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        
        labelChosenCur3.backgroundColor = .white
        labelChosenCur3.textAlignment = .center
        
        buttonResult.backgroundColor = .darkGray
        buttonResult.setTitleColor(.white, for: .normal)
        let butResult = NSLocalizedString("butResult", comment: "")
        buttonResult.setTitle(butResult, for: .normal)
        buttonResult.addAction(UIAction { [weak self] _ in
            self?.curHistory()
        }, for: .primaryActionTriggered)
        
        buttonBack.backgroundColor = .darkGray
        buttonBack.setTitleColor(.white, for: .normal)
        let butBack = NSLocalizedString("butBackCur", comment: "")
        buttonBack.setTitle(butBack, for: .normal)
        buttonBack.addAction(UIAction { [unowned self] _ in
            dismiss(animated: true)
        }, for: .primaryActionTriggered)
        
        view.addSubview(labelChooseCur)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addSubview(buttonChosenCurBase)
        view.addSubview(labelChosenCurBase)
        view.addSubview(buttonChosenCur1)
        view.addSubview(labelChosenCur1)
        view.addSubview(buttonChosenCur2)
        view.addSubview(labelChosenCur2)
        view.addSubview(buttonChosenCur3)
        view.addSubview(labelChosenCur3)
        view.addSubview(buttonResult)
        view.addSubview(buttonBack)
        
        labelChooseCur.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(0)
            make.top.equalTo(view).inset(40)
            make.height.equalTo(60)
        }
        
        startDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(80)
            make.width.equalTo(75)
            make.height.equalTo(50)
            make.top.equalTo(view).inset(120)
        }
        
        endDatePicker.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(80)
            make.width.equalTo(75)
            make.height.equalTo(50)
            make.top.equalTo(view).inset(120)
        }
        
        buttonChosenCurBase.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(0)
            make.width.equalTo(200)
            make.top.equalTo(view).inset(180)
            make.height.equalTo(60)
        }
        
        labelChosenCurBase.snp.makeConstraints{ make in
            make.trailing.equalTo(view).inset(0)
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(180)
            make.height.equalTo(60)
        }
        
        buttonChosenCur1.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(0)
            make.width.equalTo(200)
            make.top.equalTo(view).inset(260)
            make.height.equalTo(60)
        }
        
        labelChosenCur1.snp.makeConstraints{ make in
            make.trailing.equalTo(view).inset(0)
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(260)
            make.height.equalTo(60)
        }
        
        buttonChosenCur2.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(0)
            make.width.equalTo(200)
            make.top.equalTo(view).inset(330)
            make.height.equalTo(60)
        }
        
        labelChosenCur2.snp.makeConstraints{ make in
            make.trailing.equalTo(view).inset(0)
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(330)
            make.height.equalTo(60)
        }
        
        buttonChosenCur3.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(0)
            make.width.equalTo(200)
            make.top.equalTo(view).inset(400)
            make.height.equalTo(60)
        }
        
        labelChosenCur3.snp.makeConstraints{ make in
            make.trailing.equalTo(view).inset(0)
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(400)
            make.height.equalTo(60)
        }
        
        buttonResult.snp.makeConstraints{ make in
            make.trailing.leading.equalTo(view).inset(0)
            make.height.equalTo(60)
            make.top.equalTo(view).inset(480)
        }
        
        buttonBack.snp.makeConstraints{ make in
            make.trailing.leading.equalTo(view).inset(0)
            make.height.equalTo(60)
            make.top.equalTo(view).inset(560)
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

        guard let chosenCurShortNameBase = chosenCurShortNameBase else {
            let alertMissedCurBase = UIAlertController(title: "Missing based currency", message: "Please, select based currency", preferredStyle: .alert)
            let okActionBase = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertMissedCurBase.addAction(okActionBase)
            present(alertMissedCurBase, animated:  true, completion: nil)
            return
        }
        
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
        print(String(data: data, encoding: .utf8)!)
        rateData = RateData(from: data)
        
        let diagramResultPage = DiagramResult()
        diagramResultPage.setData(coordinates: coordinates(), coordinates2: coordinates2(), coordinates3: coordinates3(), chosenCur1: chosenCurShortName1 ?? "", chosenCur2: chosenCurShortName2 ?? "", chosenCur3: chosenCurShortName3 ?? "")

        diagramResultPage.modalPresentationStyle = .fullScreen
        present(diagramResultPage, animated: true)
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


