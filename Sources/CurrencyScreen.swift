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
    private var searchContr = UISearchController()
    
    // temporary collection to order data of every currency from list
    private var dictCurrency: OrderedDictionary<Character,[(String,String)]> = [:]
    
    private var searchBarEmpty: Bool {
        guard let text = searchContr.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchContr.isActive && !searchBarEmpty
    }
    
    // chosen row of currency that is needed to use in convertion operation
    private var chosenRow: IndexPath = []
    
    // list of currencies with short and long names which is used to show up on the tableView
    private var symbols = [(String, String)]()
    
    // chosen full name of currency for cells #1...4 are stored here or cell is empty
    var onCurrencySelected1: String?
    // chosen short name of currency for cells #1...4 are stored here or cell is empty
    var onCurrencySelectedShort1: String?
    
    weak var delegateToConverterScreen: CurrencyScreenDelegate?
    
    private var sortedDictCurrency: OrderedDictionary<Character, [(String, String)]> = [:]
    private var filteredDictCurrency: OrderedDictionary<Character, [(String, String)]> = [:]
    private var sectionKey: Character?
    var valueForDelegate: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the view controller to the text of nameOfScreen
        self.navigationItem.titleView = nameOfScreen
        // Ensure the navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
        
        // searchBar setting
        searchContr.searchResultsUpdater = self
        searchContr.obscuresBackgroundDuringPresentation = false
        searchContr.searchBar.placeholder = NSLocalizedString("searchCurrency", comment: "")
        navigationItem.searchController = searchContr
        navigationItem.hidesSearchBarWhenScrolling = false // Add this line
        definesPresentationContext = true
        
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
        sortedDictCurrency = dictCurrency

        tableView.register(cellWithClass: MyTableViewCell.self)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(doSwipeRight(_:)))
        swipeRightGesture.direction = .right
        
        // adding objects to the screen with currencies list
        view.addSubview(nameOfScreen)
        view.addSubview(tableView)
        view.addSubview(selectButton)
        view.addGestureRecognizer(swipeRightGesture)

        
        // Constraints for objects on the screen with currencies list
        nameOfScreen.snp.makeConstraints { make in
            make.top.equalTo(view).inset(50)
            make.leading.equalTo(view).inset(105)
            make.width.equalTo(180)
            make.height.equalTo(40)
        }
        
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
    
    @objc private func doSwipeRight (_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            delegationOfValue()
            Coordinator.closeAnotherScreen(from: self)
        }
    }

    // here is setting of cell of tableView and defines If mark picture should be used beside chosen currency
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        let contact = contact(for: indexPath)
        
        var currency: OrderedDictionary<Character,[(String,String)]> = [:]
        if isFiltering {
            currency = filteredDictCurrency
        } else {
            currency = sortedDictCurrency
        }
        
        if indexPath != chosenRow {
            cell?.setup(text: currency[sectionKey!]?[indexPath.row].1 ?? "", isChecked: true)
        } else {
            cell?.setup(text: currency[sectionKey!]?[indexPath.row].1 ?? "", isChecked: false)
        }
        cell?.backgroundColor = .black
        return cell!
    }

    // here we receiving every currency from currencies list according to order for the next processing
    private func contact(for indexPath: IndexPath) -> (String, String)? {
        let keyArray = Array(sortedDictCurrency.keys)
        sectionKey = keyArray[indexPath.section]
        let contactSection = sortedDictCurrency[sectionKey!]
        return contactSection?[indexPath.row]
    }

    // here we defines how many rows should be in every section and If there is no currency for some letter then there wont be any row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = Array(sortedDictCurrency.keys)[section]
        if isFiltering {
            return sortedDictCurrency[key]?.count ?? 0
        } else {
            return sortedDictCurrency[key]?.count ?? 0
        }
    }
    
    // here is set amount of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedDictCurrency.keys.count
    }
    
    // here is set styling details and title for every section of tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 15, height: 40))
        let key = Array(sortedDictCurrency.keys)
        lbl.text = String(key[section])
        lbl.font = UIFont(name: "DMSans-Bold", size: 20)
        lbl.textColor = SetColorByCode.hexStringToUIColor(hex: "#646464")
        lbl.backgroundColor = .black
        view.addSubview(lbl)
        return view
    }

    
    // here are operations that will be done after click to any row with currency name; chosen row with currency saves and uses for transportation to the first screen "ConverterScreen"
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contact(for: indexPath)
        
        onCurrencySelected1 = contact?.1 ?? ""
        onCurrencySelectedShort1 = contact?.0 ?? ""

        chosenRow = indexPath
        self.valueForDelegate = onCurrencySelectedShort1 ?? ""
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
            self?.delegationOfValue()
            Coordinator.closeAnotherScreen(from: self!)
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
    
    func delegationOfValue() {
        self.delegateToConverterScreen?.transferCurShortName(currency: self.valueForDelegate)
    }
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

extension CurrencyScreen: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filteredContentForSearchText(_ searchText: String) {
        filteredDictCurrency = [:] // Clear previous filtered results
        
        // Iterate over each key-value pair in the original dictionary
        for (key, values) in sortedDictCurrency {
            // Filter the values array based on the search text
            let filteredValues = values.filter { $0.1.contains(searchText) }
            // If there are filtered values, add them to the filtered dictionary
            if !filteredValues.isEmpty {
                filteredDictCurrency[key] = filteredValues
            }
        }
        
        // Reload the table view data
        tableView.reloadData()
    }
}

