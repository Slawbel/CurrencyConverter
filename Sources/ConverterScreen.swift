import SnapKit
import UIKit



class ConverterScreen: UIViewController {
    private let inputCurButton = UIButton()
    private let inputCurLabel = UILabel()
    private let inputTF = UITextField()
    
    private let outputCurButton = UIButton()
    private let outputCurLabel = UILabel()
    private let outputLabel = UILabel()
    
    private let datePicker = UIDatePicker()
    
    private let swapButton = UIButton()
    private let buttonRateHistory = UIButton()
    private let buttonDiagramPage = UIButton()
    
    private var result: String?
    private var chosenCurrency: String!
    var chosenCurShortName1: String!
    var chosenCurShortName2: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")

        inputCurButton.backgroundColor = .darkGray
        inputCurButton.setTitleColor(.white, for: .normal)
        let inputCurBut = NSLocalizedString("inputCurBut", comment: "")
        inputCurButton.setTitle(inputCurBut, for: .normal)
        inputCurButton.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelectedShort1 = { [weak self] shortName in
                self?.chosenCurShortName1 = shortName
                self?.inputCurLabel.text = shortName
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.present(currencyScreen, animated: true)

        }, for: .primaryActionTriggered)

        inputCurLabel.textAlignment = .center
        inputCurLabel.backgroundColor = .white
        
        inputTF.placeholder = NSLocalizedString("writeTheAmount", comment: "")
        inputTF.textAlignment = .center
        inputTF.backgroundColor = .white
        inputTF.addTarget(self, action: #selector(ConverterScreen.onTextFieldTextChanged(textField:)), for: .editingChanged)

        outputCurButton.backgroundColor = .darkGray
        outputCurButton.setTitleColor(.white, for: .normal)
        let outputCurBut = NSLocalizedString("outputCurBut", comment: "")
        outputCurButton.setTitle(outputCurBut, for: .normal)
        outputCurButton.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelectedShort2 = { [weak self] shortName in
                self?.chosenCurShortName2 = shortName
                self?.outputCurLabel.text = shortName
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.present(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)

        outputCurLabel.textAlignment = .center
        outputCurLabel.backgroundColor = .white

        outputLabel.textAlignment = .center
        outputLabel.backgroundColor = .white
        
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(ConverterScreen.datePickerValueChanged(_:)), for: .valueChanged)
    
        swapButton.backgroundColor = .darkGray
        swapButton.setTitleColor(.white, for: .normal)
        let swap = NSLocalizedString("swap", comment: "")
        swapButton.setTitle(swap, for: .normal)
        
        buttonRateHistory.backgroundColor = .darkGray
        buttonRateHistory.setTitleColor(.white, for: .normal)
        let butRateHistory = NSLocalizedString("transfer", comment: "")
        buttonRateHistory.setTitle(butRateHistory, for: .normal)
        buttonRateHistory.addAction(UIAction { [weak self] _ in
            let rateHistoryPage = RateHistoryPage()
            rateHistoryPage.short1 = self?.chosenCurShortName1
            rateHistoryPage.short2 = self?.chosenCurShortName2
            rateHistoryPage.modalPresentationStyle = .fullScreen
            self?.present(rateHistoryPage, animated: true)
        }, for: .primaryActionTriggered)
        
        buttonDiagramPage.backgroundColor = .darkGray
        buttonDiagramPage.setTitleColor(.white, for: .normal)
        let butDiagramPage = NSLocalizedString("diagramPage", comment: "")
        buttonDiagramPage.setTitle(butDiagramPage, for: .normal)
        buttonDiagramPage.addAction(UIAction { [weak self] _ in
            let diagramPage = DiagramPage()
            diagramPage.modalPresentationStyle = .fullScreen
            self?.present(diagramPage, animated: true)
        }, for: .primaryActionTriggered)

        view.addSubview(inputCurButton)
        view.addSubview(inputCurLabel)
        view.addSubview(inputTF)
        view.addSubview(outputCurButton)
        view.addSubview(outputCurLabel)
        view.addSubview(outputLabel)
        view.addSubview(swapButton)
        view.addSubview(buttonRateHistory)
        view.addSubview(datePicker)
        view.addSubview(buttonDiagramPage)

        inputCurButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.top.equalTo(view).inset(40)
            make.height.equalTo(80)
        }

        inputCurLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(80)
            make.width.equalTo(85)
            make.top.equalTo(view).inset(40)
            make.height.equalTo(80)
        }

        inputTF.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(170)
            make.top.equalTo(view).inset(40)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
        }

        outputCurButton.snp.makeConstraints { make in
            make.width.equalTo(80)
            make.top.equalTo(view).inset(125)
            make.height.equalTo(80)
        }

        outputCurLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(80)
            make.width.equalTo(85)
            make.top.equalTo(view).inset(125)
            make.height.equalTo(80)
        }

        outputLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(170)
            make.top.equalTo(view).inset(125)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
        }
        
        datePicker.snp.makeConstraints { make in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(50)
            make.top.equalTo(view).inset(210)
        }

        swapButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.top.equalTo(view).inset(265)
            make.height.equalTo(80)
            make.leading.equalTo(view).inset(0)
        }

        buttonRateHistory.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(265)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
        }
        
        buttonDiagramPage.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(350)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
        }
    }
    
    private var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: datePicker.date)
    }
    
    func convert() {
        let string = "https://api.apilayer.com/fixer/convert?to=" + (chosenCurShortName2 ?? "") + "&from=" + (chosenCurShortName1 ?? "") + "&amount=" + (inputTF.text ?? "0") + "&date=" + currentDate
        guard let url = URL(string: string) else {
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("mUGIIf6VCrvec8zDdJv2EofmA4euGt2z", forHTTPHeaderField: "apikey")
        //let data = Date()
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error  in
            guard let data = data else {
                return
            }
            print(String(data: data, encoding: .utf8)!)
            guard let convertResult = ConvertResult(from: data) else {
                return
            }
            DispatchQueue.main.async {
                self?.outputLabel.text = (String(convertResult.result ?? 0))
            }
        }
        task.resume()
    }
    
    @objc func onTextFieldTextChanged(textField: UITextField) {
        updateLabel(textField: textField)
    }
    
    func updateLabel(textField: UITextField) {
        convert()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        convert()
    }
}
