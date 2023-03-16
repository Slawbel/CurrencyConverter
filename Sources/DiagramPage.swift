import UIKit
import SnapKit
import SwifterSwift

class DiagramPage: UIViewController {
    private let label1 = UILabel(frame: .init(x: 10, y: 30, width: 400, height: 50))
    private let label2 = UILabel(frame: .init(x: 10, y: 100, width: 400, height: 50))
    private let label3 = UILabel(frame: .init(x: 10, y: 160, width: 400, height: 50))
    private let label4 = UILabel(frame: .init(x: 10, y: 220, width: 400, height: 50))
    private let label5 = UILabel(frame: .init(x: 10, y: 280, width: 400, height: 50))
    private let dateTextView = UITextView(frame: .init(x: 10, y: 300, width: 300, height: 50))
    private var rates = [(String, Double)]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray
        label1.backgroundColor = .red
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        view.addSubview(dateTextView)
    }
    
    func curHistory() {
        let currencyScr = CurrencyScreen()
        guard (currencyScr.onCurrencySelectedShort1 != nil) || (currencyScr.onCurrencySelectedShort2 != nil) else {
            return
        }
        
        let stringUrl = "https://api.apilayer.com/fixer/\(dateTextView.text)?symbols=\(currencyScr.onCurrencySelectedShort2)&base=\(currencyScr.onCurrencySelectedShort1)"
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
        
        guard let rateData = RateData(from: data) else {
            return
        }
        
        rates = rateData.rates.map { $0 }
        label1.text = rates.map {$1} as? String
        
        
    }
}
