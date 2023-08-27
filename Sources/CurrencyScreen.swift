import SnapKit
import UIKit
import SwifterSwift

class CurrencyScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let nameOfScreen = UILabel()
    private let tableView = UITableView()
    private var backButton = UIButton()
    private let search = UITextField()
    
    private var symbols = [(String, String)]()
    var onCurrencySelected1: ((String) -> Void)?
    var onCurrencySelected2: ((String) -> Void)?
    var onCurrencySelected3: ((String) -> Void)?
    var onCurrencySelected4: ((String) -> Void)?
    var onCurrencySelectedShort1: ((String) -> Void)?
    var onCurrencySelectedShort2: ((String) -> Void)?
    var onCurrencySelectedShort3: ((String) -> Void)?
    var onCurrencySelectedShort4: ((String) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameOfScreen.textAlignment = .center
        nameOfScreen.backgroundColor = .clear
        nameOfScreen.textColor = .white
        nameOfScreen.text = NSLocalizedString("nameOfScreen", comment: "")
        nameOfScreen.font = nameOfScreen.font.withSize(24)
        
        //search.keyboardType = .asciiCapableNumberPad
        search.keyboardAppearance = .dark
        let placeholderForSearchtTF = NSLocalizedString("searchCurrency", comment: "")
        search.textAlignment = .left
        search.backgroundColor = .clear
        search.textColor = .white
        //search.addTarget(self, action: #selector(CurrencyScreen.search), for: .editingChanged)
        search.attributedPlaceholder = NSAttributedString(
            string: placeholderForSearchtTF, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        
        tableView.register(cellWithClass: MyTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        findCur()
        
        
        backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .primaryActionTriggered)
    

        view.addSubview(nameOfScreen)
        view.addSubview(search)
        view.addSubview(tableView)
        view.addSubview(backButton)

        
        nameOfScreen.snp.makeConstraints { make in
            make.top.equalTo(view).inset(58)
            make.leading.equalTo(view).inset(105)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        search.snp.makeConstraints { make in
            make.top.equalTo(view).inset(114)
            make.leading.equalTo(view).inset(15)
            make.width.equalTo(360)
            make.height.equalTo(45)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(746)
            make.leading.equalTo(view).inset(15)
            make.width.equalTo(360)
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(183)
            make.height.equalTo(529)
            make.width.equalTo(336)
            make.leading.trailing.equalTo(view).inset(21)
        }
        
        

        
    }


    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        //let curShortNameFlag = ConverterScreen.getFlagToLabel(symbols[indexPath.row].0)
        //guard curShortNameFlag != nil else { return }
        let textWithCurrencyAndFlag = symbols[indexPath.row].1
        cell?.setup(text: textWithCurrencyAndFlag)
        cell?.backgroundColor = .black
        
        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        symbols.count
    }

    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCur = symbols[indexPath.row].1
        let selectedCur2 = symbols[indexPath.row].0
        onCurrencySelected1?(selectedCur)
        onCurrencySelected2?(selectedCur)
        onCurrencySelected3?(selectedCur)
        onCurrencySelected4?(selectedCur)
        onCurrencySelectedShort1?(selectedCur2)
        onCurrencySelectedShort2?(selectedCur2)
        onCurrencySelectedShort3?(selectedCur2)
        onCurrencySelectedShort4?(selectedCur2)
    }
    
    func testGradientButton() -> Void {
        let gradientColor = CAGradientLayer()
        gradientColor.startPoint = CGPoint(x: 1, y: 0.5)
        gradientColor.endPoint = CGPoint(x: 0, y: 0.5)
        gradientColor.locations = [0.0 , 1.0]
        let color0 = UIColor(red: 8.0/255.0, green: 0.0/255.0, blue: 12.0/255.0, alpha: 1)
        let color1 = UIColor(red: 197.0/255.0, green: 83.0/255.0, blue: 237.0/255.0, alpha: 1)
        let color2 = UIColor(red: 237.0/255.0, green: 98.0/255.0, blue: 177.0/255.0, alpha: 1)
        let color3 = UIColor(red: 255.0/255.0, green: 143.0/255.0, blue: 52.0/255.0, alpha: 1)
        gradientColor.colors = [color0.cgColor, color1.cgColor,color2.cgColor,color3.cgColor]
        gradientColor.frame = backButton.bounds
        self.backButton.layer.insertSublayer(gradientColor, at: 0)
    }
    
    private func findCur() {
        let stringUrl = "https://api.apilayer.com/fixer/symbols"
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
        
        guard let curData = CurData(from: data) else {
            return
        }
        symbols = curData.symbols.map { $0 }
        symbols.sort{ $0.1 < $1.1 }
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testGradientButton()
        
        backButton.layer.cornerRadius = 20
        let buttonBack = NSLocalizedString("buttonBack", comment: "")
        let font1 = UIFont(name: "DMSans-Bold", size: 16)
        let attributes1: [NSAttributedString.Key: Any] = [
            .font: font1 ?? "DMSans-Regular",
            .foregroundColor: UIColor.white,
            .kern: 2]
        let attributeButtonText = NSAttributedString(string: buttonBack, attributes: attributes1)
        backButton.setAttributedTitle(attributeButtonText, for: .normal)
                
        backButton.masksToBounds = true
    }
}



