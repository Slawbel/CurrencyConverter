import SnapKit
import CoreData
import UIKit
import SwifterSwift
import OrderedCollections



class CurrencyScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // elements of screen
    private let nameOfScreen = UILabel()
    private var tableView = UITableView()
    private var selectButton = UIButton()
    //private lazy var searchContr = UISearchTextField()
    
    // temporary collection to order data of every currency from list
    private var dictCurrency: OrderedDictionary<Character,[(String,String)]> = [:]
    
    // chosen row of currency that is needed to use in convertion operation
    private var chosenRow: IndexPath = []
    
    // list of currencies with short and long names which is used to show up on the tableView
    private var symbols = [(String, String)]()
    private var symbolsForSearch = [String]()
    private var symbolsAfterSearch = [String]()
    
    // chosen full name of currency for cells #1...4 are stored here or cell is empty
    var onCurrencySelected1: ((String) -> Void)?
    var onCurrencySelected2: ((String) -> Void)?
    var onCurrencySelected3: ((String) -> Void)?
    var onCurrencySelected4: ((String) -> Void)?
    // chosen short name of currency for cells #1...4 are stored here or cell is empty
    var onCurrencySelectedShort1: ((String) -> Void)?
    var onCurrencySelectedShort2: ((String) -> Void)?
    var onCurrencySelectedShort3: ((String) -> Void)?
    var onCurrencySelectedShort4: ((String) -> Void)?
    
    var filteredDictCurrency: OrderedDictionary<Character, [(String, String)]> = [:]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // style setting of name label of the screen
        nameOfScreen.textAlignment = .center
        nameOfScreen.backgroundColor = .clear
        nameOfScreen.textColor = .white
        nameOfScreen.text = NSLocalizedString("nameOfScreen", comment: "")
        nameOfScreen.font = nameOfScreen.font.withSize(24)
        
        // here data is trying to be downloaded from DataCore
        tableView.dataSource = self
        tableView.delegate = self
        returnData()
        print("RETURNING WAS DONE")
        
        // temporary collection for editing
        var currencyDict = [String: String]()
        
        // in case of empty "symbols": api request is being made and uploaded currencies list to CoreData memory;
        // in case of non-empty "symbols": the process continues to the next step and temporary collection "currencyDict" obtains short and full names of currencies from "symbols"
        if symbols.isEmpty {
            print("Way1")
            findCur()
        } else {
            print("Way2")
        }
        for n in symbols {
            currencyDict[n.0] = n.1
        }
        
        // sorting of temporary collection "currencyDict" and transferring to collection "dictCurrency"
        for n in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
            var tempArray: [(String,String)] = []
            for m in currencyDict {
                let letter = m.value[0]
                if n == letter {
                    tempArray.append((m.key, m.value))
                }
            }
            dictCurrency[n] = tempArray.sorted(by: { $0.1 < $1.1 })
        }

        
        // removing of empty elements and its key
        for i in dictCurrency.keys {
            if dictCurrency[i] == nil {
                dictCurrency.removeValue(forKey: i)
            }
        }
        

        tableView.register(cellWithClass: MyTableViewCell.self)
        
        //searchContr.addTarget(self, action: #selector(CurrencyScreen.searchHandler), for: .editingChanged)
        
        filteredDictCurrency = dictCurrency
        print(filteredDictCurrency)
        
        // adding objects to the screen with currencies list
        view.addSubview(nameOfScreen)
        view.addSubview(tableView)
        view.addSubview(selectButton)
        //view.addSubview(searchContr)

        
        // Constraints for objects on the screen with currencies list
        nameOfScreen.snp.makeConstraints { make in
            make.top.equalTo(view).inset(50)
            make.leading.equalTo(view).inset(105)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
        /*searchContr.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(114)
            make.leading.equalTo(view).inset(15)
            make.width.equalTo(360)
            make.height.equalTo(45)
        }*/
        
        selectButton.snp.makeConstraints { make in
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

    // here is setting of cell of tableView and defines If mark picture should be used beside chosen currency
    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        let contact = contact(for: indexPath)
        self.symbolsForSearch.append(contact?.1 ?? "")
        if indexPath != chosenRow {
            cell?.setup(text: contact?.1 ?? "", isChecked: true)
        } else {
            cell?.setup(text: contact?.1 ?? "", isChecked: false)
        }
        cell?.backgroundColor = .black
        return cell!
    }

    // here we receiving every currency from currencies list according to order for the next processing
    private func contact(for indexPath: IndexPath) -> (String, String)? {
        let keyArray = Array(filteredDictCurrency.keys)
        let sectionKey = keyArray[indexPath.section]
        let contactSection = filteredDictCurrency[sectionKey]
        return contactSection?[indexPath.row]
    }

    // here we defines how many rows should be in every section and If there is no currency for some letter then there wont be any row
    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(filteredDictCurrency.keys)[section]
        return filteredDictCurrency[key]?.count ?? 0
    }
    
    // here is set amount of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredDictCurrency.keys.count
    }
    
    // here is set styling details and title for every section of tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 15, height: 40))
        let key = Array(filteredDictCurrency.keys)
        lbl.text = String(key[section])
        lbl.font = UIFont(name: "DMSans-Regular", size: 20)
        lbl.textColor = SetColorByCode.hexStringToUIColor(hex: "#646464")
        view.addSubview(lbl)
        return view
    }
    
    // here are operations that will be done after click to any row with currency name; chosen row with currency saves and uses for transportation to the first screen "ConverterScreen"
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contact(for: indexPath)
        let selectedCur: String
        let selectedCur2: String
        selectedCur = contact?.1 ?? ""
        selectedCur2 = contact?.0 ?? ""
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
    
    // here is set what will be done after out of click
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            cell.accessoryType = .none
        }
    }
    
    // here is defined height value of every row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    // this function is implemented for gradient usage; values of color enters below and there should be defined way of gradient and distance between points where colors should be set
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
        gradientColor.frame = selectButton.bounds
        self.selectButton.layer.insertSublayer(gradientColor, at: 0)
    }
    
    // this is api for calling currencies list an then it saves to CoreData memory
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
        
        guard let curData = CurData(from: data) else {
            return
        }
        symbols = curData.symbols.map { $0 }
        symbols.sort{ $0.1 < $1.1 }
        tableView.reloadData()
        
        createData()
    }
    
    // this function updates code for the screen when it was already appeared and some styiling details should set for objects
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        testGradientButton()
        
        tableView.backgroundColor = .black
        
        /*searchContr.layerCornerRadius = 20
        let colorForSearchPlaceholder = SetColorByCode.hexStringToUIColor(hex: "#646464")
        searchContr.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("searchCurrency", comment: ""), attributes: [NSAttributedString.Key.foregroundColor : colorForSearchPlaceholder])
        searchContr.font = UIFont(name: "DMSans-Regular", size: 14)
        searchContr.textColor = .white
        searchContr.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#181B20")*/
        
        selectButton.layer.cornerRadius = 20
        let buttonBack = NSLocalizedString("buttonBack", comment: "")
        let font1 = UIFont(name: "DMSans-Bold", size: 16)
        let attributes1: [NSAttributedString.Key: Any] = [
            .font: font1 ?? "DMSans-Regular",
            .foregroundColor: UIColor.white,
            .kern: 2]
        let attributeButtonText = NSAttributedString(string: buttonBack, attributes: attributes1)
        selectButton.setAttributedTitle(attributeButtonText, for: .normal)
        
        selectButton.addAction(UIAction { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }, for: .primaryActionTriggered)
                
        selectButton.masksToBounds = true
    }
    
    // recording (refreshing) of currencies list to CoreData memory
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
    
    // downloading currencies list from CoreData
    func returnData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Currencies")

        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                self.symbols.append((data.value(forKey: "shortNameOfCurrency") as! String, data.value(forKey: "longNameOfCurrency") as! String))
            }
        } catch {
            print("Failed returning")
        }
    }
    
    // deleting currencies list from CoreData memory
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
    
    /*@objc func searchHandler (_ sender: UITextField, textDidChange searchText: String) {
        if let searchText = sender.text {
            filteredDictCurrency = [:]
            let dictValues = [:]
            if searchText == "" {
                filteredDictCurrency = dictCurrency
            }
            for word in dictValues.values {
                if word.uppercased().contains(searchText.uppercased()) {
                    filteredDictCurrency.append(word)
                }
            }
            self.tableView.reloadData()
            
        }
    }*/
}


// extension is used to support function to delete data from CoreData memory
extension NSManagedObjectContext {
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObject] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [self])
    }
}
