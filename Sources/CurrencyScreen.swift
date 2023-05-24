import SnapKit
import UIKit
import SwifterSwift

class CurrencyScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let backButton = UIButton()
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

        backButton.backgroundColor = .white
        backButton.setTitleColor(.black, for: .normal)
        let buttonBack = NSLocalizedString("buttonBack", comment: "")
        backButton.setTitle(buttonBack, for: .normal)

        view.addSubview(tableView)
        view.addSubview(backButton)

        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(680)
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(80)
            make.bottom.equalTo(view).inset(200)
            make.leading.trailing.equalTo(view).inset(50)
        }
        
        backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .primaryActionTriggered)

        tableView.register(cellWithClass: MyTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        findCur()
    }


    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        cell?.setup(text: symbols[indexPath.row].1)
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
}
