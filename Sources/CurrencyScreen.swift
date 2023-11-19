import SnapKit
import CoreData
import UIKit
import SwifterSwift
import OrderedCollections



class CurrencyScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    private let nameOfScreen = UILabel()
    private var tableView = UITableView()
    private var backButton = UIButton()
    private lazy var searchContr = UISearchTextField()
    private var dictCurrency: OrderedDictionary<Character,[String]> = [:]
    private var chosenRow: IndexPath = []
    private var symbols = [(String, String)]()
    var onCurrencySelected1: ((String) -> Void)?
    var onCurrencySelected2: ((String) -> Void)?
    var onCurrencySelected3: ((String) -> Void)?
    var onCurrencySelected4: ((String) -> Void)?
    var onCurrencySelectedShort1: ((String) -> Void)?
    var onCurrencySelectedShort2: ((String) -> Void)?
    var onCurrencySelectedShort3: ((String) -> Void)?
    var onCurrencySelectedShort4: ((String) -> Void)?
    var cachedSymbols = [(String, String)]()
    private var dateString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameOfScreen.textAlignment = .center
        nameOfScreen.backgroundColor = .clear
        nameOfScreen.textColor = .white
        nameOfScreen.text = NSLocalizedString("nameOfScreen", comment: "")
        nameOfScreen.font = nameOfScreen.font.withSize(24)
        
        tableView.dataSource = self
        tableView.delegate = self
        if cachedSymbols.isEmpty {
            returnData()
            print("Returning was done")
        }
        
        var currencyDict = Set<String>()
        
        dateRecording()
        
        if cachedSymbols.isEmpty {
            findCur()
            print("Way1")
            for n in symbols {
                currencyDict.insert(n.1)
            }
        } else {
            print("Way2")
            for n in cachedSymbols {
                currencyDict.insert(n.1)
            }
        }
        for n in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
            var tempArray: Array<String> = []
            for m in currencyDict {
                let letter = m[m.startIndex]
                if n == letter {
                    tempArray.append(m)
                }
            }
            dictCurrency[n] = tempArray.sorted(by: { $0 < $1 })
        }
        
        // removing of empty elements and its key
        for i in dictCurrency.keys {
            if dictCurrency[i] == [] {
                dictCurrency.removeValue(forKey: i)
            }
        }
        
        tableView.register(cellWithClass: MyTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(nameOfScreen)
        view.addSubview(tableView)
        view.addSubview(backButton)
        view.addSubview(searchContr)
        
        nameOfScreen.snp.makeConstraints { make in
            make.top.equalTo(view).inset(50)
            make.leading.equalTo(view).inset(105)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        searchContr.snp.makeConstraints{ make in
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
            make.top.equalTo(view).inset(160)
            make.height.equalTo(529)
            make.width.equalTo(336)
            make.leading.trailing.equalTo(view).inset(21)
        }
        
    }
    
    
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keyArray = Array(dictCurrency.keys)
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        let sectionKey = keyArray[indexPath.section]
        let contactSection = dictCurrency[sectionKey]
        let contact = contactSection?[indexPath.row]
        if indexPath != chosenRow {
            cell?.setup(text: contact ?? "", isChecked: true)
        } else {
            cell?.setup(text: contact ?? "", isChecked: false)
        }
        cell?.backgroundColor = .black
        return cell!
    }
    
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(dictCurrency.keys)[section]
        return dictCurrency[key]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictCurrency.keys.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 15, height: 40))
        let key = Array(dictCurrency.keys)
        lbl.text = String(key[section])
        lbl.font = UIFont(name: "DMSans-Regular", size: 20)
        let colorForSectionTitle = ConverterScreen().hexStringToUIColor(hex: "#646464")
        lbl.textColor = colorForSectionTitle
        view.addSubview(lbl)
        
        return view
    }
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCur: String
        var selectedCur2: String
        if cachedSymbols.isEmpty {
            selectedCur = symbols[indexPath.row].1
            selectedCur2 = symbols[indexPath.row].0
        } else {
            selectedCur = cachedSymbols[indexPath.row].1
            selectedCur2 = cachedSymbols[indexPath.row].0
        }
        onCurrencySelected1?(selectedCur)
        onCurrencySelected2?(selectedCur)
        onCurrencySelected3?(selectedCur)
        onCurrencySelected4?(selectedCur)
        onCurrencySelectedShort1?(selectedCur2)
        onCurrencySelectedShort2?(selectedCur2)
        onCurrencySelectedShort3?(selectedCur2)
        onCurrencySelectedShort4?(selectedCur2)
        chosenRow = indexPath
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    
    func testGradientButton() -> Void {
        let gradientColor = CAGradientLayer()
        gradientColor.startPoint = CGPoint(x: 1, y: 0)
        gradientColor.endPoint = CGPoint(x: 0, y: 0.5)
        gradientColor.locations = [0.0 , 1.0]
        let color0 = UIColor(red: 77.0/255.0, green: 30.0/255.0, blue: 95.0/255.0, alpha: 1)
        let color1 = UIColor(red: 237.0/255.0, green: 98.0/255.0, blue: 177.0/255.0, alpha: 1)
        let color2 = UIColor(red: 249.0/255.0, green: 128.0/255.0, blue: 93.0/255.0, alpha: 1)
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
        //print(String(data: data, encoding: .utf8)!)
        
        guard let curData = CurData(from: data) else {
            return
        }
        symbols = curData.symbols.map { $0 }
        symbols.sort{ $0.1 < $1.1 }
        tableView.reloadData()
        
        createData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testGradientButton()
        
        tableView.backgroundColor = .black
        
        searchContr.layerCornerRadius = 20
        let colorForSearchPlaceholder = ConverterScreen().hexStringToUIColor(hex: "#646464")
        searchContr.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("searchCurrency", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : colorForSearchPlaceholder])
        searchContr.font = UIFont(name: "DMSans-Regular", size: 14)
        searchContr.textColor = .white
        let colorForSearchContr = ConverterScreen().hexStringToUIColor(hex: "#181B20")
        searchContr.backgroundColor = colorForSearchContr
        
        backButton.layer.cornerRadius = 20
        let buttonBack = NSLocalizedString("buttonBack", comment: "")
        let font1 = UIFont(name: "DMSans-Bold", size: 16)
        let attributes1: [NSAttributedString.Key: Any] = [
            .font: font1 ?? "DMSans-Regular",
            .foregroundColor: UIColor.white,
            .kern: 2]
        let attributeButtonText = NSAttributedString(string: buttonBack, attributes: attributes1)
        backButton.setAttributedTitle(attributeButtonText, for: .normal)
        
        backButton.addAction(UIAction { [weak self] _ in
            self?.dismiss(animated: true)
        }, for: .primaryActionTriggered)
        
        backButton.masksToBounds = true
    }
    
    // recording of data in CoreData
    func createData() {
        removeData()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        for i in self.symbols {
            let entity = NSEntityDescription.entity(forEntityName: "Currencies", in: managedContext)
            let currency = NSManagedObject(entity: entity!, insertInto: managedContext)
            currency.setValue(i.0, forKey: "shortNameOfCurrency")
            currency.setValue(i.1, forKey: "longNameOfCurrency")
        }
        
        do {
            try managedContext.save()
            print("SAVING WAS DONE")
        } catch {
            print("Failed while saving")
        }
    }
    
    func returnData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Currencies")
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                self.cachedSymbols.append((data.value(forKey: "shortNameOfCurrency") as! String, data.value(forKey: "longNameOfCurrency") as! String))
            }
        } catch {
            print("Failed returning")
        }
    }
    
    func removeData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Currencies")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.executeAndMergeChanges(using: batchDeleteRequest)
        } catch {
            print("Failed removing")
        }
    }
    
    func dateRecording() {
        // save as String
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm"
        let str = df.string(from: Date())
        UserDefaults.standard.setValue(str, forKey: "key")
        
        if str != self.dateString {
            removeData()
            self.dateString = str
        }
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
    
    func writingToFile() {
        let dateString = "Hello, World!"

        if let data = dateString.data(using: .utf8) {
            do {
                try data.write(to: userProfileURL)
                print("Successfully wrote to file!")
            } catch {
                print("Error writing to file: \(error)")
            }
        }
    }
}


extension NSManagedObjectContext {
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObject] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
