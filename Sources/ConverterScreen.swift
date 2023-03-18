import SnapKit
import UIKit

class ConverterScreen: UIViewController {
    private let inputCurButton = UIButton()
    private let inputCurLabel = UILabel()
    private let inputTF = UITextField()
    
    private let outputCurButton = UIButton()
    private let outputCurLabel = UILabel()
    private let outputLabel = UILabel()
    
    private let rateLabel = UILabel()
    private let dateButton = UIButton()
    private let dateLabel = UILabel()
    
    private let swapButton = UIButton()
    private let buttonDiagram = UIButton()
    
    private var result: String?
    private var chosenCurrency: String!
    private var chosenCurShortName1: String!
    private var chosenCurShortName2: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")

        inputCurButton.backgroundColor = .darkGray
        inputCurButton.setTitleColor(.black, for: .normal)
        let inputCurBut = NSLocalizedString("inputCurBut", comment: "")
        inputCurButton.setTitle(inputCurBut, for: .normal)
        inputCurButton.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelected1 = { [weak self] currency in
                self?.chosenCurrency = currency
                
            }
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

        outputCurButton.backgroundColor = .darkGray
        outputCurButton.setTitleColor(.black, for: .normal)
        let outputCurBut = NSLocalizedString("outputCurBut", comment: "")
        outputCurButton.setTitle(outputCurBut, for: .normal)
        outputCurButton.addAction(UIAction { [unowned self] _ in
            let currencyScreen = CurrencyScreen()
            currencyScreen.onCurrencySelected2 = { [weak self] currency in
                self?.chosenCurrency = currency
                self?.outputCurLabel.text = currency
            }
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
        
        rateLabel.textAlignment = .center
        rateLabel.backgroundColor = .white

        
        dateButton.backgroundColor = .darkGray
        dateButton.setTitleColor(.black, for: .normal)
        let dateBut = NSLocalizedString("date", comment: "")
        dateButton.setTitle(dateBut, for: .normal)
        
        dateLabel.textAlignment = .center
        dateLabel.backgroundColor = .white
        

        swapButton.backgroundColor = .darkGray
        swapButton.setTitleColor(.black, for: .normal)
        let swap = NSLocalizedString("swap", comment: "")
        swapButton.setTitle(swap, for: .normal)
        
        buttonDiagram.backgroundColor = .darkGray
        buttonDiagram.setTitleColor(.black, for: .normal)
        let buttonDiagramText = NSLocalizedString("transfer", comment: "")
        buttonDiagram.setTitle(buttonDiagramText, for: .normal)
        buttonDiagram.addAction(UIAction { [unowned self] _ in
            let diagramPage = DiagramPage()
            diagramPage.modalPresentationStyle = .fullScreen
            self.present(diagramPage, animated: true)
        }, for: .primaryActionTriggered)

        view.addSubview(inputCurButton)
        view.addSubview(inputCurLabel)
        view.addSubview(inputTF)
        view.addSubview(outputCurButton)
        view.addSubview(outputCurLabel)
        view.addSubview(outputLabel)
        view.addSubview(rateLabel)
        view.addSubview(dateButton)
        view.addSubview(dateLabel)
        view.addSubview(swapButton)
        view.addSubview(buttonDiagram)

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
        
        rateLabel.snp.makeConstraints{ make in
            make.width.equalTo(165)
            make.top.equalTo(view).inset(210)
            make.height.equalTo(80)
            make.leading.equalTo(view).inset(0)
        }
        
        dateButton.snp.makeConstraints{ make in
            make.width.equalTo(80)
            make.top.equalTo(view).inset(210)
            make.height.equalTo(80)
            make.leading.equalTo(view).inset(170)
        }
        
        dateLabel.snp.makeConstraints{make in
            make.leading.equalTo(view).inset(250)
            make.top.equalTo(view).inset(210)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
            
        }

        
        swapButton.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.top.equalTo(view).inset(295)
            make.height.equalTo(80)
            make.leading.equalTo(view).inset(0)
        }

        buttonDiagram.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(295)
            make.height.equalTo(80)
            make.trailing.equalTo(view).inset(0)
        }
    }
    
    func convert() {
        let string = "https://api.apilayer.com/fixer/convert?to=" + (chosenCurShortName2 ?? "") + "&from=" + (chosenCurShortName1 ?? "") + "&amount=" + (inputTF.text ?? "0")
        guard let url = URL(string: string) else {
            return
        }
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.addValue("mUGIIf6VCrvec8zDdJv2EofmA4euGt2z", forHTTPHeaderField: "apikey")
        //let data = Date()
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data else {
                return
            }
            print(String(data: data, encoding: .utf8)!)
            guard let convertResult = ConvertResult(from: data) else {
                return
            }
            DispatchQueue.main.async {
                self.outputLabel.text = (String(convertResult.result ?? 0))
            }
        }
        task.resume()
    }
}
