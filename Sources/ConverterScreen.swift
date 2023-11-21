import SnapKit
import UIKit



class ConverterScreen: UIViewController {

    let userProfileURL: URL =
    
    private let nameLabel = UILabel()
    
    // currency for conversion
    private let stackView = UIStackView()
    private let inputCurLabel = UILabel()
    private let inputCurrencyLabel = UILabel()
    private let inputCurButton = UIButton()
    private let inputTF = UITextField()
    
    // currency #1
    private let stackView1 = UIStackView()
    private let outputCurLabel1 = UILabel()
    private let outputCurrencyLabel1 = UILabel()
    private let outputCurButton1 = UIButton()
    private let outputLabel1 = UILabel()
    
    //currency#2
    private let stackView2 = UIStackView()
    private let outputCurLabel2 = UILabel()
    private let outputCurrencyLabel2 = UILabel()
    private let outputCurButton2 = UIButton()
    private let outputLabel2 = UILabel()
    
    //currency#3
    private let stackView3 = UIStackView()
    private let outputCurLabel3 = UILabel()
    private let outputCurrencyLabel3 = UILabel()
    private let outputCurButton3 = UIButton()
    private let outputLabel3 = UILabel()

    private let datePicker = UIDatePicker()
    private let swapButton1 = UIButton()
    private let swapButton2 = UIButton()
    private let swapButton3 = UIButton()
    private let addButton = UIButton()
    
    private let buttonRateHistory = UIButton()
    private let buttonDiagramPage = UIButton()
   
    
    private var result1: String?
    private var result2: String?
    private var result3: String?
    private var chosenCurrency: String!
    var chosenCurShortName: String!
    var chosenCurShortName1: String!
    var chosenCurShortName2: String!
    var chosenCurShortName3: String!
    
    var counterOfClick = 0
   


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .init(named: "mainBackgroundColor")
        
        nameLabel.textAlignment = .center
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .white
        nameLabel.text = NSLocalizedString("nameLabelText", comment: "")
        nameLabel.font = nameLabel.font.withSize(24)
        
        stackView.axis = .vertical
        let colorForStackView = hexStringToUIColor(hex: "#181B20")
        stackView.backgroundColor = colorForStackView
        stackView.layer.cornerRadius = 20
        
        inputCurLabel.textAlignment = .center
        
        let font = UIFont(name: "DMSans-Regular", size: 14)
        inputCurLabel.font = font
        inputCurLabel.textColor = .white
        inputCurLabel.backgroundColor = .clear
        inputCurLabel.text = NSLocalizedString("inputCurLabelText", comment: "")
        
        inputCurrencyLabel.text = "               >"
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
                self?.chosenCurShortName = shortName
                self?.inputCurrencyLabel.text = shortName + "      >"
                self?.convert()
                let cutShortNameFlag = self?.getFlagToLabel(shortName: shortName)
                guard cutShortNameFlag != nil else { return }
                if cutShortNameFlag != nil {
                    self?.inputCurrencyLabel.text = cutShortNameFlag! + " " + shortName + " >"
                } else { return }
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        

        
        datePicker.timeZone = NSTimeZone.local
        datePicker.overrideUserInterfaceStyle = .dark
        let colorForIDatePickerText = hexStringToUIColor(hex: "#2B333A")
        datePicker.backgroundColor = colorForIDatePickerText
        datePicker.datePickerMode = .date
        datePicker.setDate(.now, animated: true)
        datePicker.addTarget(self, action: #selector(ConverterScreen.convert), for: .valueChanged)
        datePicker.layer.cornerRadius = 8
        datePicker.setValue(UIColor.white, forKey: "textColor")
        
        inputTF.keyboardType = .asciiCapableNumberPad
        inputTF.keyboardAppearance = .dark
        let placeholderForInputTF = NSLocalizedString("writeTheAmount", comment: "")
        inputTF.textAlignment = .right
        inputTF.backgroundColor = .clear
        inputTF.textColor = .white
        inputTF.addTarget(self, action: #selector(ConverterScreen.convert), for: .editingChanged)
        inputTF.attributedPlaceholder = NSAttributedString(
            string: placeholderForInputTF, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // currency #1
        stackView1.axis = .vertical
        let colorForStackView1 = hexStringToUIColor(hex: "#181B20")
        stackView1.backgroundColor = colorForStackView1
        stackView1.layer.cornerRadius = 20
        
        outputCurLabel1.textAlignment = .left
        outputCurLabel1.font = outputCurLabel1.font.withSize(14)
        outputCurLabel1.textColor = .white
        outputCurLabel1.backgroundColor = .clear
        outputCurLabel1.text = NSLocalizedString("outputCurLabelText", comment: "")
        
        outputCurrencyLabel1.text = "               >"
        outputCurrencyLabel1.textAlignment = .center
        outputCurrencyLabel1.font = outputCurrencyLabel1.font.withSize(14)
        outputCurrencyLabel1.textColor = .white
        outputCurrencyLabel1.backgroundColor = .clear
        
        outputCurButton1.layer.cornerRadius = 10
        let colorForOutputCurButton = hexStringToUIColor(hex: "#2B333A")
        outputCurButton1.backgroundColor = colorForOutputCurButton
        outputCurButton1.setTitleColor(.white, for: .normal)
        outputCurButton1.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelectedShort2 = { [weak self] shortName in
                self?.chosenCurShortName1 = shortName
                self?.outputCurrencyLabel1.text = shortName + "      >"
                self?.convert()
                let cutShortNameFlag = self?.getFlagToLabel(shortName: shortName)
                guard cutShortNameFlag != nil else { return }
                if cutShortNameFlag != nil {
                    self?.outputCurrencyLabel1.text = cutShortNameFlag! + " " + shortName + " >"
                } else { return }
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        
        outputLabel1.backgroundColor = .clear
        outputLabel1.textAlignment = .right
        outputLabel1.textColor = .white
        outputLabel1.font = outputCurrencyLabel1.font.withSize(18)
        outputLabel1.text = "0"
        
        // currency #2
        stackView2.axis = .vertical
        let colorForStackView2 = hexStringToUIColor(hex: "#181B20")
        stackView2.backgroundColor = colorForStackView2
        stackView2.layer.cornerRadius = 20
        stackView2.isHidden = true
        
        outputCurLabel2.textAlignment = .left
        outputCurLabel2.font = outputCurLabel2.font.withSize(14)
        outputCurLabel2.textColor = .white
        outputCurLabel2.backgroundColor = .clear
        outputCurLabel2.text = NSLocalizedString("outputCurLabelText", comment: "")
        outputCurLabel2.isHidden = true
        
        outputCurrencyLabel2.text = "               >"
        outputCurrencyLabel2.textAlignment = .center
        outputCurrencyLabel2.font = outputCurrencyLabel2.font.withSize(14)
        outputCurrencyLabel2.textColor = .white
        outputCurrencyLabel2.backgroundColor = .clear
        outputCurrencyLabel2.isHidden = true
        
        outputCurButton2.layer.cornerRadius = 10
        let colorForOutputCurButton2 = hexStringToUIColor(hex: "#2B333A")
        outputCurButton2.backgroundColor = colorForOutputCurButton2
        outputCurButton2.setTitleColor(.white, for: .normal)
        outputCurButton2.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelectedShort3 = { [weak self] shortName in
                self?.chosenCurShortName2 = shortName
                self?.outputCurrencyLabel2.text = shortName + "      >"
                self?.convert()
                let cutShortNameFlag = self?.getFlagToLabel(shortName: shortName)
                guard cutShortNameFlag != nil else { return }
                if cutShortNameFlag != nil {
                    self?.outputCurrencyLabel2.text = cutShortNameFlag! + " " + shortName + " >"
                } else { return }
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        outputCurButton2.isHidden = true
        
        outputLabel2.backgroundColor = .clear
        outputLabel2.textAlignment = .right
        outputLabel2.textColor = .white
        outputLabel2.font = outputCurrencyLabel1.font.withSize(18)
        outputLabel2.text = "0"
        outputLabel2.isHidden = true
        
        // currency #3
        stackView3.axis = .vertical
        let colorForStackView3 = hexStringToUIColor(hex: "#181B20")
        stackView3.backgroundColor = colorForStackView3
        stackView3.layer.cornerRadius = 20
        stackView3.isHidden = true
        
        outputCurLabel3.textAlignment = .left
        outputCurLabel3.font = outputCurLabel3.font.withSize(14)
        outputCurLabel3.textColor = .white
        outputCurLabel3.backgroundColor = .clear
        outputCurLabel3.text = NSLocalizedString("outputCurLabelText", comment: "")
        outputCurLabel3.isHidden = true
        
        outputCurrencyLabel3.text = "               >"
        outputCurrencyLabel3.textAlignment = .center
        outputCurrencyLabel3.font = outputCurrencyLabel3.font.withSize(14)
        outputCurrencyLabel3.textColor = .white
        outputCurrencyLabel3.backgroundColor = .clear
        outputCurrencyLabel3.isHidden = true
        
        outputCurButton3.layer.cornerRadius = 10
        let colorForOutputCurButton3 = hexStringToUIColor(hex: "#2B333A")
        outputCurButton3.backgroundColor = colorForOutputCurButton3
        outputCurButton3.setTitleColor(.white, for: .normal)
        outputCurButton3.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelectedShort4 = { [weak self] shortName in
                self?.chosenCurShortName3 = shortName
                self?.outputCurrencyLabel3.text = shortName + "      >"
                self?.convert()
                let cutShortNameFlag = self?.getFlagToLabel(shortName: shortName)
                guard cutShortNameFlag != nil else { return }
                if cutShortNameFlag != nil {
                    self?.outputCurrencyLabel3.text = cutShortNameFlag! + " " + shortName + " >"
                } else { return }
            }
            currencyScreen.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(currencyScreen, animated: true)
        }, for: .primaryActionTriggered)
        outputCurButton3.isHidden = true
        
        outputLabel3.backgroundColor = .clear
        outputLabel3.textAlignment = .right
        outputLabel3.textColor = .white
        outputLabel3.font = outputCurrencyLabel1.font.withSize(18)
        outputLabel3.text = "0"
        outputLabel3.isHidden = true
        
        
        let colorForSwapButton1 = hexStringToUIColor(hex: "#0F0F0F")
        swapButton1.backgroundColor = colorForSwapButton1
        swapButton1.layer.cornerRadius = 19
        let swapSymbol1 = UIImage(named: "icon_swap_vertical")
        swapButton1.setImage(swapSymbol1, for: .normal)
        swapButton1.addTarget(self, action: #selector(swapCurrency1), for: .touchUpInside)
        
        swapButton2.backgroundColor = colorForSwapButton1
        swapButton2.layer.cornerRadius = 19
        swapButton2.setImage(swapSymbol1, for: .normal)
        swapButton2.addTarget(self, action: #selector(swapCurrency2), for: .touchUpInside)
        swapButton2.isHidden = true
        

        swapButton3.backgroundColor = colorForSwapButton1
        swapButton3.layer.cornerRadius = 19
        swapButton3.setImage(swapSymbol1, for: .normal)
        swapButton3.addTarget(self, action: #selector(swapCurrency3), for: .touchUpInside)
        swapButton3.isHidden = true
        
        
        addButton.backgroundColor = colorForStackView
        addButton.layer.cornerRadius = 18.5
        let addSymbol = UIImage(named: "icon_plus")
        addButton.setImage(addSymbol, for: .normal)
        addButton.addTarget(self, action: #selector(addCurrency), for: .touchUpInside)
        
        buttonRateHistory.backgroundColor = colorForStackView
        buttonRateHistory.layer.cornerRadius = 12
        buttonRateHistory.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        buttonRateHistory.setTitleColor(.white, for: .normal)
        buttonRateHistory.addAction(UIAction { [weak self] _ in
            let rateHistoryPage = RateHistoryPage()
            rateHistoryPage.short1 = self?.chosenCurShortName
            rateHistoryPage.short2 = self?.chosenCurShortName1
            rateHistoryPage.modalPresentationStyle = .fullScreen
            self?.present(rateHistoryPage, animated: true)
        }, for: .primaryActionTriggered)
        let buttonRateHistoryImage = UIImage(named: "icon_history")
        buttonRateHistory.setImage(buttonRateHistoryImage, for: .normal)
        let buttonRateHistoryTitle = NSLocalizedString("transfer", comment: "")
        buttonRateHistory.setTitle(buttonRateHistoryTitle, for: .normal)
        
        buttonDiagramPage.backgroundColor = colorForStackView
        buttonDiagramPage.layer.cornerRadius = 12
        buttonDiagramPage.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        buttonDiagramPage.setTitleColor(.white, for: .normal)
        buttonDiagramPage.addAction(UIAction { [weak self] _ in
            let diagramPage = DiagramPage()
            diagramPage.modalPresentationStyle = .fullScreen
            self?.present(diagramPage, animated: true)
        }, for: .primaryActionTriggered)
        let buttonDiagramPageImage = UIImage(named: "icon_graph")
        buttonDiagramPage.setImage(buttonDiagramPageImage, for: .normal)
        let buttonDiagramPageTitle = NSLocalizedString("diagramPage", comment: "")
        buttonDiagramPage.setTitle(buttonDiagramPageTitle, for: .normal)
        
    
        view.addSubview(nameLabel)
        view.addSubview(stackView)
        stackView.addSubview(inputCurLabel)
        stackView.addSubview(inputCurButton)
        inputCurButton.addSubview(inputCurrencyLabel)
        stackView.addSubview(datePicker)
        stackView.addSubview(inputTF)
        
        view.addSubview(stackView1)
        stackView1.addSubview(outputCurLabel1)
        stackView1.addSubview(outputCurButton1)
        outputCurButton1.addSubview(outputCurrencyLabel1)
        stackView1.addSubview(outputLabel1)
        
        view.addSubview(stackView2)
        stackView2.addSubview(outputCurLabel2)
        stackView2.addSubview(outputCurButton2)
        outputCurButton2.addSubview(outputCurrencyLabel2)
        stackView2.addSubview(outputLabel2)
        
        view.addSubview(stackView3)
        stackView3.addSubview(outputCurLabel3)
        stackView3.addSubview(outputCurButton3)
        outputCurButton3.addSubview(outputCurrencyLabel3)
        stackView3.addSubview(outputLabel3)
        
        view.addSubview(swapButton1)
        view.addSubview(swapButton2)
        view.addSubview(swapButton3)
        view.addSubview(addButton)
        view.addSubview(buttonRateHistory)
        view.addSubview(buttonDiagramPage)

    
        
        nameLabel.snp.makeConstraints{ make in
            make.width.equalTo(222)
            make.height.equalTo(40)
            make.leading.equalTo(view).inset(84)
            make.top.equalTo(view.snp.top).inset(44)
        }
        
        // basic currency for conversion
        stackView.snp.makeConstraints{ make in
            make.leading.equalTo(view.snp.leading).inset(13)
            make.width.equalTo(360)
            make.top.equalTo(view.snp.top).inset(94)
            make.height.equalTo(95)
        }
        
        inputCurLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(38)
            make.width.equalTo(186)
            make.top.equalTo(view).inset(114)
            make.height.equalTo(17)
        }
        
        inputCurrencyLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(47)
            make.top.equalTo(view).inset(152)
            make.width.equalTo(75)
            make.height.equalTo(13)
        }
        
        inputCurButton.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(36)
            make.top.equalTo(view).inset(143)
            make.width.equalTo(103)
            make.height.equalTo(28)
        }
        
        datePicker.snp.makeConstraints { make in
            make.width.equalTo(117)
            make.height.equalTo(25)
            make.top.equalTo(view).inset(94)
            make.leading.equalTo(view).inset(256)
        }
        
        inputTF.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(202)
            make.top.equalTo(view).inset(138)
            make.height.equalTo(40)
            make.width.equalTo(147)
        }
        
        // currency #1
        stackView1.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(13)
            make.top.equalTo(view).inset(195)
            make.width.equalTo(360)
            make.height.equalTo(95)
        }
        
        outputCurLabel1.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(38)
            make.width.equalTo(255)
            make.top.equalTo(view).inset(215)
            make.height.equalTo(17)
        }
        
        outputCurrencyLabel1.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(47)
            make.width.equalTo(75)
            make.top.equalTo(view).inset(253)
            make.height.equalTo(13)
        }
        
        outputCurButton1.snp.makeConstraints { make in
            make.width.equalTo(103)
            make.top.equalTo(view).inset(244)
            make.height.equalTo(27)
            make.leading.equalTo(view).inset(36)
        }
        
        outputLabel1.snp.makeConstraints { make in
            make.width.equalTo(73)
            make.top.equalTo(view).inset(239)
            make.height.equalTo(40)
            make.leading.equalTo(view).inset(278)
        }
        
        // currency #2
        stackView2.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(13)
            make.top.equalTo(view).inset(296)
            make.width.equalTo(360)
            make.height.equalTo(95)
        }
        
        outputCurLabel2.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(38)
            make.width.equalTo(255)
            make.top.equalTo(view).inset(316)
            make.height.equalTo(17)
        }

        outputCurrencyLabel2.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(47)
            make.width.equalTo(75)
            make.top.equalTo(view).inset(354)
            make.height.equalTo(13)
        }
        
        outputCurButton2.snp.makeConstraints { make in
            make.width.equalTo(103)
            make.top.equalTo(view).inset(345)
            make.height.equalTo(27)
            make.leading.equalTo(view).inset(36)
        }
        
        outputLabel2.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.top.equalTo(view).inset(339)
            make.height.equalTo(40)
            make.leading.equalTo(view).inset(289)
        }
        
        //currency #3
        stackView3.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(13)
            make.top.equalTo(view).inset(397)
            make.width.equalTo(360)
            make.height.equalTo(95)
        }
        
        outputCurLabel3.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(38)
            make.width.equalTo(255)
            make.top.equalTo(view).inset(417)
            make.height.equalTo(17)
        }

        outputCurrencyLabel3.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(47)
            make.width.equalTo(75)
            make.top.equalTo(view).inset(455)
            make.height.equalTo(13)
        }
        
        outputCurButton3.snp.makeConstraints { make in
            make.width.equalTo(103)
            make.top.equalTo(view).inset(446)
            make.height.equalTo(27)
            make.leading.equalTo(view).inset(36)
        }
        
        outputLabel3.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.top.equalTo(view).inset(440)
            make.height.equalTo(40)
            make.leading.equalTo(view).inset(289)
        }
        
        // buttons
        swapButton1.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.top.equalTo(view).inset(175)
            make.height.equalTo(38)
            make.leading.equalTo(view).inset(227)
        }
        
        swapButton2.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.top.equalTo(view).inset(276)
            make.height.equalTo(38)
            make.leading.equalTo(view).inset(227)
        }
        
        swapButton3.snp.makeConstraints { make in
            make.width.equalTo(38)
            make.top.equalTo(view).inset(377)
            make.height.equalTo(38)
            make.leading.equalTo(view).inset(229)
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(177)
            make.top.equalTo(view).inset(370)
            make.width.height.equalTo(37)
        }
        
        buttonRateHistory.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(16)
            make.top.equalTo(view).inset(296)
            make.height.equalTo(40)
            make.width.equalTo(176)
        }
        
        buttonDiagramPage.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(198)
            make.top.equalTo(view).inset(296)
            make.height.equalTo(40)
            make.width.equalTo(176)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    var currentDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var stringDate = dateFormatter.string(from: datePicker.date)
            writingDateToTheFile(stringDate)
            return stringDate
    }
    
    
    @objc func swapCurrency1() {
        let tempCur = inputCurrencyLabel.text
        inputCurrencyLabel.text = outputCurrencyLabel1.text
        outputCurrencyLabel1.text = tempCur
    }
    
    @objc func swapCurrency2() {
        let tempCur = inputCurrencyLabel.text
        inputCurrencyLabel.text = outputCurrencyLabel2.text
        outputCurrencyLabel2.text = tempCur
    }
    
    @objc func swapCurrency3() {
        let tempCur = inputCurrencyLabel.text
        inputCurrencyLabel.text = outputCurrencyLabel3.text
        outputCurrencyLabel3.text = tempCur
    }

    
    @objc func addCurrency() {
        if counterOfClick == 0 {
            stackView2.isHidden = false
            outputCurLabel2.isHidden = false
            outputCurrencyLabel2.isHidden = false
            outputCurButton2.isHidden = false
            outputLabel2.isHidden = false
            swapButton2.isHidden = false
            counterOfClick+=1
            
            
            addButton.snp.remakeConstraints { make in
                make.leading.equalTo(view).inset(177)
                make.top.equalTo(view).inset(471)
                make.width.height.equalTo(37)
            }
            
            buttonRateHistory.snp.remakeConstraints { make in
                make.leading.equalTo(view).inset(16)
                make.top.equalTo(view).inset(397)
                make.height.equalTo(40)
                make.width.equalTo(176)
            }
            
            buttonDiagramPage.snp.remakeConstraints{ make in
                make.leading.equalTo(view).inset(198)
                make.top.equalTo(view).inset(397)
                make.height.equalTo(40)
                make.width.equalTo(176)
            }
        } else {
            stackView3.isHidden = false
            outputCurLabel3.isHidden = false
            outputCurrencyLabel3.isHidden = false
            outputCurButton3.isHidden = false
            outputLabel3.isHidden = false
            addButton.isHidden = true
            swapButton3.isHidden = false
            counterOfClick = 0
            
            buttonRateHistory.snp.remakeConstraints { make in
                make.leading.equalTo(view).inset(16)
                make.top.equalTo(view).inset(498)
                make.height.equalTo(40)
                make.width.equalTo(176)
            }
            
            buttonDiagramPage.snp.remakeConstraints{ make in
                make.leading.equalTo(view).inset(198)
                make.top.equalTo(view).inset(498)
                make.height.equalTo(40)
                make.width.equalTo(176)
            }
        }
    }

    @objc
    func convert() {
        let currencyApi = CurrencyApi()
        currencyApi.apiChosenCurShortName1 = chosenCurShortName
        currencyApi.apiChosenCurShortName2 = chosenCurShortName1
        currencyApi.apiChosenCurShortName3 = chosenCurShortName2
        currencyApi.apiChosenCurShortName4 = chosenCurShortName3
        
        currencyApi.apiInputTF = inputTF.text
        currencyApi.apiChosenDate = currentDate
        currencyApi.conversion2 { [weak self] convertResult in
            self?.outputLabel1.text = String(convertResult.result ?? 0)
        }
        currencyApi.conversion3 { [weak self] convertResult in
            self?.outputLabel2.text = String(convertResult.result ?? 0)
        }
        currencyApi.conversion4 { [weak self] convertResult in
            self?.outputLabel3.text = String(convertResult.result ?? 0)
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
    

    func flag(country:String) -> String {
        let base : UInt32 = 127397
        var s = ""
        for v in country.unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
    
    func getFlagToLabel (shortName: String) -> String? {
        var cutShortNameFlag: String?
        if shortName != "BTC" && shortName != "XOF" && shortName != "XAF" && shortName != "XPF" && shortName != "STD" && shortName != "XAG" && shortName != "XAU" {
            var cutShortName = shortName
            cutShortName.removeLast()
            cutShortNameFlag = flag(country: cutShortName)
            
        }
        return cutShortNameFlag
    }
    
    
    
    func createDirectoryForFile() {
        let fileManager = FileManager.default
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let checkDateURL = documentsURL.appendingPathComponent("CheckDate")
        
        do {
            try FileManager.default.createDirectory(at: checkDateURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating directory: \(error)")
        }
        let userProfileURL = checkDateURL.appendingPathComponent("userProfile.txt")
    }
    
    func writingDateToTheFile(_ dateString: String) {
        if let data = dateString.data(using: .utf8) {
            do {
                try data.write(to: userProfileURL)
                print("Successfully wrote to file!")
            } catch {
                print("Error writing to file: \(error)")
            }
        }
    }
    
    func deleteSavedDate() {
        do {
            try FileManager.default.removeItem(at: userProfileURL)
            print("Successfully deleted file!")
        } catch {
            print("Error deleting file: \(error)")
        }
    }

}

