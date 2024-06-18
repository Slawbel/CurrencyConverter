import SnapKit
import CoreData
import UIKit
import SwifterSwift
import OrderedCollections

class CurrencyScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // Elements of the screen
    private let nameOfScreen = UILabel()
    private var tableView = UITableView()
    private var selectButton = UIButton()
    private var searchContr = UISearchController()
    
    // Temporary collection to order data of every currency from the list
    private var dictCurrency: OrderedDictionary<Character, [(String, String)]> = [:]
    
    private var searchBarEmpty: Bool {
        guard let text = searchContr.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchContr.isActive && !searchBarEmpty
    }
    
    // Chosen row of currency that is needed to use in the conversion operation
    private var chosenRow: IndexPath = []
    
    // List of currencies with short and long names which are used to show up on the tableView
    private var symbols = [(String, String)]()
    private var symbolsForSearch = [String]()
    
    // Chosen full name of currency for cells #1...4 are stored here or the cell is empty
    var onCurrencySelected1: String?
    // Chosen short name of currency for cells #1...4 are stored here or the cell is empty
    var onCurrencySelectedShort1: String?
    
    weak var delegateToConverterScreen: CurrencyScreenDelegate?
    
    private var sortedDictCurrency: OrderedDictionary<Character, [(String, String)]> = [:]
    private var filteredDictCurrency: OrderedDictionary<Character, [(String, String)]> = [:]
    private var sectionKey: Character?
    var valueForDelegate: String = ""
    
    // Variable to store the selected currency symbol
    private var selectedCurrencySymbol: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title of the view controller to the text of nameOfScreen
        self.navigationItem.titleView = nameOfScreen
        // Ensure the navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
        
        // Ensure the navigation bar appearance does not change on scroll
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black // Set your desired color
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Set title text color
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Set large title text color
            
            navigationBar.standardAppearance = appearance
            navigationBar.scrollEdgeAppearance = appearance
        }
        
        // SearchBar setting
        searchContr.searchResultsUpdater = self
        searchContr.obscuresBackgroundDuringPresentation = false
        searchContr.searchBar.placeholder = NSLocalizedString("searchCurrency", comment: "")
        navigationItem.searchController = searchContr
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        
        // Customize search bar text color
        let searchTextField = searchContr.searchBar.searchTextField
        searchTextField.textColor = .white // Set your desired text color here
        
        // Customize placeholder text color
        let placeholderText = NSLocalizedString("searchCurrency", comment: "")
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray // Set your desired placeholder text color here
        ]
        searchTextField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        
        // Style setting of name label of the screen
        nameOfScreen.textAlignment = .center
        nameOfScreen.backgroundColor = .clear
        nameOfScreen.textColor = .white
        nameOfScreen.text = NSLocalizedString("nameOfScreen", comment: "")
        nameOfScreen.font = nameOfScreen.font.withSize(24)
        
        // Here data is trying to be downloaded from CoreData
        tableView.dataSource = self
        tableView.delegate = self
        returnData()
        print("RETURNING WAS DONE")
        
        // Hide scroll indicators
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        // Temporary collection for editing
        var currencyDict = [String: String]()
        
        // In case of empty "symbols": api request is being made and uploaded currencies list to CoreData memory;
        // In case of non-empty "symbols": the process continues to the next step and temporary collection "currencyDict" obtains short and full names of currencies from "symbols"
        if symbols.isEmpty {
            print("Way1")
            findCur()
        } else {
            print("Way2")
        }
        for n in symbols {
            currencyDict[n.0] = n.1
        }
        
        // Sorting of temporary collection "currencyDict" and transferring to collection "dictCurrency"
        for n in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" {
            var tempArray: [(String, String)] = []
            for m in currencyDict {
                let letter = m.value.first
                if n == letter {
                    tempArray.append((m.key, m.value))
                }
            }
            dictCurrency[n] = tempArray.sorted(by: { $0.1 < $1.1 })
        }
        
        // Removing of empty elements and their key
        for key in dictCurrency.keys {
            if dictCurrency[key]?.isEmpty == true {
                dictCurrency.removeValue(forKey: key)
            }
        }
        sortedDictCurrency = dictCurrency
        
        tableView.register(cellWithClass: MyTableViewCell.self)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(doSwipeRight(_:)))
        swipeRightGesture.direction = .right
        
        // Adding objects to the screen with currencies list
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
    
    // Here is the setting of the cell of tableView and defines if the mark picture should be used beside the chosen currency
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        let contact = contact(for: indexPath)
        
        self.symbolsForSearch.append(contact?.1 ?? "")
        
        // Check if the cell should be checked based on the selected currency symbol
        let isChecked = (contact?.0 == selectedCurrencySymbol)
        cell?.setup(text: contact?.1 ?? "", isChecked: !isChecked)
        
        cell?.backgroundColor = .black
        return cell!
    }
    
    // Here we are receiving every currency from the currencies list according to the order for the next processing
    private func contact(for indexPath: IndexPath) -> (String, String)? {
        var currency: OrderedDictionary<Character, [(String, String)]>
        if isFiltering {
            currency = filteredDictCurrency
        } else {
            currency = sortedDictCurrency
        }
        
        let keyArray = Array(currency.keys)
        guard indexPath.section < keyArray.count else {
            return nil
        }
        let sectionKey = keyArray[indexPath.section]
        let contactSection = currency[sectionKey]
        return contactSection?[indexPath.row]
    }
    
    // Here we define how many rows should be in every section and if there is no currency for some letter then there won't be any row
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currency: OrderedDictionary<Character, [(String, String)]>
        if isFiltering {
            currency = filteredDictCurrency
        } else {
            currency = sortedDictCurrency
        }
        
        let keyArray = Array(currency.keys)
        guard section < keyArray.count else {
            return 0
        }
        let sectionKey = keyArray[section]
        return currency[sectionKey]?.count ?? 0
    }
    
    // Here is set the amount of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering {
            return filteredDictCurrency.keys.count
        } else {
            return sortedDictCurrency.keys.count
        }
    }
    
    // Here is set styling details and title for every section of tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        view.backgroundColor = .black
        let lbl = UILabel(frame: CGRect(x: 10, y: 0, width: tableView.frame.width - 10, height: 30))
        
        let currency: OrderedDictionary<Character, [(String, String)]>
        if isFiltering {
            currency = filteredDictCurrency
        } else {
            currency = sortedDictCurrency
        }
        
        let keyArray = Array(currency.keys)
        guard section < keyArray.count else {
            return nil
        }
        let sectionKey = keyArray[section]
        lbl.text = String(sectionKey)
        lbl.font = UIFont(name: "DMSans-Bold", size: 20)
        lbl.textColor = .white
        view.addSubview(lbl)
        return view
    }
    
    // Here are operations that will be done after clicking any row with currency name; chosen row with currency saves and uses for transportation to the first screen "ConverterScreen"
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = contact(for: indexPath)
        onCurrencySelected1 = contact?.1 ?? ""
        onCurrencySelectedShort1 = contact?.0 ?? ""
        
        selectedCurrencySymbol = onCurrencySelectedShort1
        
        chosenRow = indexPath
        self.valueForDelegate = onCurrencySelectedShort1 ?? ""
        tableView.reloadData()
    }
    
    // This method is called when a row is deselected
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        // Here, you can perform any operations you need when a row is deselected
    }
    
    // Here is defined the height value of every row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // This function is implemented for gradient usage; values of color enter below and there should be defined the way of gradient and distance between points where colors should be set
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
    
    // This function updates the UI components when the view appears
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
    
    // Recording (refreshing) of currencies list to CoreData memory
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
    
    // Downloading currencies list from CoreData
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
    
    // Deleting currencies list from CoreData memory
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
}

// Extension is used to support function to delete data from CoreData memory
extension NSManagedObjectContext {
    public func executeAndMergeChanges(using batchDeleteRequest: NSBatchDeleteRequest) throws {
        batchDeleteRequest.resultType = .resultTypeObjectIDs
        let result = try execute(batchDeleteRequest) as? NSBatchDeleteResult
        let changes: [AnyHashable: Any] = [NSDeletedObjectsKey: result?.result as? [NSManagedObject] ?? []]
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable: Any], into: [self])
    }
}

extension NSPersistentContainer {
    public func batchDelete(_ entities: [NSManagedObject]) throws {
        let context = newBackgroundContext()
        context.performAndWait {
            for object in entities {
                context.delete(object)
            }
            do {
                try context.save()
            } catch {
                print("Error saving context after batch delete: \(error)")
            }
        }
    }
}

extension NSBatchDeleteRequest {
    public convenience init(fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        self.init(fetchRequest: fetchRequest)
        resultType = .resultTypeObjectIDs
    }
}

extension CurrencyScreen: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // Get the text from the search bar
        guard let searchText = searchController.searchBar.text else { return }

        // Filter the dictionary based on the search text
        filteredDictCurrency = sortedDictCurrency.mapValues { $0.filter { $0.1.localizedCaseInsensitiveContains(searchText) } }

        // Reload the table view data to reflect the changes
        tableView.reloadData()
    }
}
