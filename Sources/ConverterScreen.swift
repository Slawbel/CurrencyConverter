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
    private let addButton = UIButton()
    
    private let buttonRateHistory = UIButton()
    private let rateHistoryLabel = UILabel()
    private let rateHistorySymbol = UILabel()
    
    private let buttonDiagramPage = UIButton()
    private let diagramLabel = UILabel()
    private let diagramSymbol = UILabel()
    
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
        inputCurrencyLabel.backgroundColor = .clear
        
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
        outputCurrencyLabel.backgroundColor = .clear
        
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
        
        
        let colorForSwapButton = hexStringToUIColor(hex: "#0F0F0F")
        swapButton.backgroundColor = colorForSwapButton
        swapButton.layer.cornerRadius = 19
        let swapSymbol = UIImage(named: "icon_swap_vertical")
        swapButton.setImage(swapSymbol, for: .normal)
        
        addButton.backgroundColor = colorForStackView
        addButton.layer.cornerRadius = 18.5
        let addSymbol = UIImage(named: "icon_plus")
        addButton.setImage(addSymbol, for: .normal)
        
        rateHistoryLabel.textAlignment = .center
        rateHistoryLabel.textColor = .white
        rateHistoryLabel.backgroundColor = .clear
        rateHistoryLabel.font = rateHistoryLabel.font.withSize(12)
        rateHistoryLabel.text = NSLocalizedString("transfer", comment: "")
        
        buttonRateHistory.backgroundColor = colorForStackView
        buttonRateHistory.layer.cornerRadius = 12
        buttonRateHistory.setTitleColor(.white, for: .normal)
        buttonRateHistory.addAction(UIAction { [weak self] _ in
            let rateHistoryPage = RateHistoryPage()
            rateHistoryPage.short1 = self?.chosenCurShortName1
            rateHistoryPage.short2 = self?.chosenCurShortName2
            rateHistoryPage.modalPresentationStyle = .fullScreen
            self?.present(rateHistoryPage, animated: true)
        }, for: .primaryActionTriggered)
        
        diagramLabel.textAlignment = .center
        diagramLabel.textColor = .white
        diagramLabel.backgroundColor = .clear
        diagramLabel.font = diagramLabel.font.withSize(12)
        diagramLabel.text = NSLocalizedString("diagramPage", comment: "")
        
        buttonDiagramPage.backgroundColor = colorForStackView
        buttonDiagramPage.layer.cornerRadius = 12
        buttonDiagramPage.setTitleColor(.white, for: .normal)
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
        
        scrollViewMain.addSubview(stackView2)
        stackView2.addSubview(outputCurLabel)
        stackView2.addSubview(outputCurButton)
        outputCurButton.addSubview(outputCurrencyLabel)
        stackView2.addSubview(outputLabel)
        
        scrollViewMain.addSubview(swapButton)
        scrollViewMain.addSubview(addButton)
        scrollViewMain.addSubview(buttonRateHistory)
        buttonRateHistory.addSubview(rateHistoryLabel)
    
        scrollViewMain.addSubview(buttonDiagramPage)
        buttonDiagramPage.addSubview(diagramLabel)
        buttonDiagramPage.addSubview(diagramSymbol)
        
        
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
        
        swapButton.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.top.equalTo(view).inset(196)
            make.height.equalTo(38)
            make.leading.equalTo(view).inset(229)
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(177)
            make.top.equalTo(view).inset(349)
            make.width.height.equalTo(37)
        }
        
        buttonRateHistory.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(16)
            make.top.equalTo(view).inset(424)
            make.height.equalTo(40)
            make.width.equalTo(176)
        }
        
        rateHistoryLabel.snp.makeConstraints{ make in
            make.leading.equalTo(buttonRateHistory.snp.leading).inset(66)
            make.top.equalTo(buttonRateHistory.snp.top).inset(5)
            make.height.equalTo(33)
            make.width.equalTo(66)
        }
        
        rateHistorySymbol.snp.makeConstraints { make in
            make.leading.equalTo(buttonRateHistory.snp.leading).inset(44)
            make.top.equalTo(buttonRateHistory.snp.top).inset(13)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
        
        buttonDiagramPage.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(198)
            make.top.equalTo(view).inset(424)
            make.height.equalTo(40)
            make.width.equalTo(176)
        }
        
        diagramLabel.snp.makeConstraints{ make in
            make.leading.equalTo(buttonDiagramPage.snp.leading).inset(75)
            make.top.equalTo(buttonDiagramPage.snp.top).inset(11)
            make.height.equalTo(20)
            make.width.equalTo(46)
        }
        
        diagramSymbol.snp.makeConstraints{ make in
            make.leading.equalTo(buttonDiagramPage.snp.leading).inset(54)
            make.top.equalTo(buttonDiagramPage.snp.top).inset(13)
            make.height.equalTo(15)
            make.width.equalTo(15)
        }
        
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


