import SnapKit
import UIKit
import SwifterSwift


class CurrencyScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController = UIViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)

        backButton.backgroundColor = .white
        backButton.setTitleColor(.black, for: .normal)
        let buttonBack = NSLocalizedString("buttonBack", comment: "")
        backButton.setTitle(buttonBack, for: .normal)

        view.addSubview(tableView)
        view.addSubview(backButton)

        
        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(650)
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

    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        40
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {}
    
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
        
        guard let currencyName = CurData(from: data) else {
            return
        }
        let outputNames = MyTableViewCell()
        let resultCurrency = CurData(from: data)
        outputNames.fullName.text = resultCurrency?.symbols as String
    }
}
