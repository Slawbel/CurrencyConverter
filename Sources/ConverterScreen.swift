import SnapKit
import UIKit



class ConverterScreen: UIViewController {
    private let scrollViewMain = UIScrollView()
    private let nameLabel = UILabel()
    
    private let stackView = UIStackView()
    private let inputCurLabel = UILabel()
    private let inputCurrencyLabel = UILabel()
    private let inputCurButton = UIButton()
    private let inputTF = UITextField()
    
    private let stackView2 = UIStackView()
    private let outputCurLabel = UILabel()
    private let outputCurrencyLabel = UILabel()
    private let outputCurButton = UIButton()
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
        
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = nil
        nameLabel.textColor = .white
        nameLabel.text = NSLocalizedString("nameLabelText", comment: "")
        nameLabel.font = nameLabel.font.withSize(24)
        
        stackView.axis = .vertical
        let colorForStackView = hexStringToUIColor(hex: "#181B20")
        stackView.backgroundColor = colorForStackView
        stackView.layer.cornerRadius = 20
        
        inputCurLabel.textAlignment = .center
        inputCurLabel.font = inputCurLabel.font.withSize(14)
        inputCurLabel.textColor = .white
        inputCurLabel.backgroundColor = .clear
        inputCurLabel.text = NSLocalizedString("inputCurLabelText", comment: "")
        
        inputCurrencyLabel.textAlignment = .center
        inputCurrencyLabel.font = inputCurrencyLabel.font.withSize(14)
        inputCurrencyLabel.textColor = .white
        inputCurrencyLabel.backgroundColor = nil
        
        inputCurButton.layer.cornerRadius = 10
        let colorForInputCurButton = hexStringToUIColor(hex: "#2B333A")
        inputCurButton.backgroundColor = colorForInputCurButton
        inputCurButton.setTitleColor(.white, for: .normal)
        inputCurButton.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelectedShort1 = { [weak self] shortName in
                self?.chosenCurShortName1 = shortName
                self?.inputCurrencyLabel.text = shortName
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.present(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)

        datePicker.timeZone = NSTimeZone.local
        datePicker.overrideUserInterfaceStyle = .light
        let colorForIDatePickerText = hexStringToUIColor(hex: "#2B333A")
        datePicker.backgroundColor = colorForIDatePickerText
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(ConverterScreen.datePickerValueChanged(_:)), for: .valueChanged)
        datePicker.layer.cornerRadius = 8
        
        let placeholderForInputTF = NSLocalizedString("writeTheAmount", comment: "")
        inputTF.textAlignment = .right
        inputTF.backgroundColor = .clear
        inputTF.textColor = .white
        inputTF.addTarget(self, action: #selector(ConverterScreen.onTextFieldTextChanged(textField:)), for: .editingChanged)
        inputTF.attributedPlaceholder = NSAttributedString(
            string: placeholderForInputTF, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        
        
        
        
        stackView2.axis = .vertical
        let colorForStackView2 = hexStringToUIColor(hex: "#181B20")
        stackView2.backgroundColor = colorForStackView2
        stackView2.layer.cornerRadius = 20

        outputCurLabel.textAlignment = .left
        outputCurLabel.font = outputCurLabel.font.withSize(14)
        outputCurLabel.textColor = .white
        outputCurLabel.backgroundColor = .clear
        outputCurLabel.text = NSLocalizedString("outputCurLabelText", comment: "")
        
        outputCurrencyLabel.textAlignment = .center
        outputCurrencyLabel.font = outputCurrencyLabel.font.withSize(14)
        outputCurrencyLabel.textColor = .white
        outputCurrencyLabel.backgroundColor = nil
        
        outputCurButton.layer.cornerRadius = 10
        let colorForOutputCurButton = hexStringToUIColor(hex: "#2B333A")
        outputCurButton.backgroundColor = colorForOutputCurButton
        outputCurButton.setTitleColor(.white, for: .normal)
        outputCurButton.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelectedShort2 = { [weak self] shortName in
                self?.chosenCurShortName2 = shortName
                self?.outputCurrencyLabel.text = shortName
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.present(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        
        outputLabel.backgroundColor = .clear
        outputLabel.textAlignment = .right
        outputLabel.textColor = .white
        outputLabel.font = outputCurrencyLabel.font.withSize(18)
        outputLabel.text = "0"

        
        
    
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
        
        view.addSubview(scrollViewMain)
        scrollViewMain.addSubview(nameLabel)
        scrollViewMain.addSubview(stackView)
        stackView.addSubview(inputCurLabel)
        stackView.addSubview(inputCurButton)
        inputCurButton.addSubview(inputCurrencyLabel)
        stackView.addSubview(datePicker)
        stackView.addSubview(inputTF)
        
        view.addSubview(stackView2)
        stackView2.addSubview(outputCurLabel)
        stackView2.addSubview(outputCurButton)
        outputCurButton.addSubview(outputCurrencyLabel)
        stackView2.addSubview(outputLabel)
        //view.addSubview(swapButton)
        //view.addSubview(buttonRateHistory)
        //view.addSubview(buttonDiagramPage)
        
        scrollViewMain.snp.makeConstraints{ make in
            make.width.height.equalTo(view).priority(.low)
            make.edges.equalTo(view)
        }
        
        nameLabel.snp.makeConstraints{ make in
            make.width.equalTo(222)
            make.height.equalTo(40)
            make.leading.equalTo(scrollViewMain.snp.leading).inset(84)
            make.top.equalTo(scrollViewMain.snp.top).inset(58)
        }
        
        stackView.snp.makeConstraints{ make in
            make.leading.equalTo(scrollViewMain.snp.leading).inset(15)
            make.width.equalTo(360)
            make.top.equalTo(scrollViewMain.snp.top).inset(115)
            make.height.equalTo(97)
        }
        
        inputCurLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(40)
            make.width.equalTo(124)
            make.top.equalTo(view).inset(123)
            make.height.equalTo(40)
        }
        
        inputCurrencyLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(77)
            make.top.equalTo(view).inset(172)
            make.width.equalTo(32)
            make.height.equalTo(13)
        }

        inputCurButton.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(38)
            make.top.equalTo(view).inset(165)
            make.width.equalTo(103)
            make.height.equalTo(28)
        }
        
        datePicker.snp.makeConstraints { make in
            make.width.equalTo(118)
            make.height.equalTo(25)
            make.top.equalTo(view).inset(115)
            make.leading.equalTo(view).inset(258)
        }
        
        inputTF.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(165)
            make.top.equalTo(view).inset(160)
            make.height.equalTo(40)
            make.width.equalTo(186)
        }
        
        
        stackView2.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(15)
            make.top.equalTo(view).inset(218)
            make.width.equalTo(360)
            make.height.equalTo(97)
        }
        
        outputCurLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(40)
            make.width.equalTo(255)
            make.top.equalTo(view).inset(238)
            make.height.equalTo(17)
        }
        
        outputCurrencyLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(77)
            make.width.equalTo(30)
            make.top.equalTo(view).inset(276)
            make.height.equalTo(13)
        }
        
        outputCurButton.snp.makeConstraints { make in
            make.width.equalTo(103)
            make.top.equalTo(view).inset(268)
            make.height.equalTo(28)
            make.leading.equalTo(view).inset(38)
        }
        
        outputLabel.snp.makeConstraints { make in
            make.width.equalTo(75)
            make.top.equalTo(view).inset(263)
            make.height.equalTo(40)
            make.leading.equalTo(view).inset(276)
        }

        /*
       
        outputLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(170)
            make.top.equalTo(view).inset(185)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
        }
        
        

        swapButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.top.equalTo(view).inset(325)
            make.height.equalTo(80)
            make.leading.equalTo(view).inset(0)
        }

        buttonRateHistory.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(325)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
        }
        
        buttonDiagramPage.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(410)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
        }*/
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    var currentDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: datePicker.date)
    }
    
    func swapFunction () {
        let temp = chosenCurShortName1
        chosenCurShortName1 = chosenCurShortName2
        chosenCurShortName2 = temp
        
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
    
    func convert() {
        let currencyApi = CurrencyApi()
        currencyApi.apiChosenCurShortName1 = chosenCurShortName1
        currencyApi.apiChosenCurShortName2 = chosenCurShortName2
        currencyApi.apiInputTF = inputTF.text
        currencyApi.apiChosenDate = currentDate
        currencyApi.conversion { [weak self] convertResult in
            self?.outputLabel.text = String(convertResult.result ?? 0)
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}


