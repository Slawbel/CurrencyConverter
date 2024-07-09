import UIKit
import DGCharts
import SnapKit

class DiagramResult: DemoBaseViewController {
    
    // redefinition of initializer without parameters
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    // required initializer for NSCoding
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    internal let diagramStackView = UIStackView()
    
    lazy var chartView = LineChartView()

    var sliderX = UISlider()
    var sliderY = UISlider()
    var sliderTextX = UITextField()
    var sliderTextY = UITextField()
    
    private var chosenCurShortNameBase: String?
    private var chosenCurShortName1: String?
    private var chosenCurShortName2: String?
    private var chosenCurShortName3: String?
    
    private let labelDiagram = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let outputCurButton1 = UIButton()
    private let outputLabel1 = UILabel()
    
    private let outputCurButton2 = UIButton()
    private let outputLabel2 = UILabel()
    
    private let outputCurButton3 = UIButton()
    private let outputLabel3 = UILabel()

    private var rateData: RateData?
    weak var diagramDelegate: DiagramResultDelegate?
    
    var selectorDiagram: UInt8 = 0


    init (inputCur: String, outputCur1: String?, outputCur2: String?, outputCur3: String?) {
        super.init(nibName: nil, bundle: nil)
        self.chosenCurShortNameBase = inputCur
        if outputCur1 != nil { self.chosenCurShortName1 = outputCur1 }
        if outputCur2 != nil { self.chosenCurShortName2 = outputCur2 }
        if outputCur3 != nil { self.chosenCurShortName3 = outputCur3 }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")
        
        self.navigationItem.titleView = labelDiagram
        if let navigationBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .black // Set your desired color
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Set title text color
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // Set large title text color
            navigationBar.standardAppearance = appearance
        }
        
        
        diagramStackView.axis = .vertical
        diagramStackView.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#181B20")
        diagramStackView.layer.cornerRadius = 30
        
        self.options = [.toggleValues,
                        .toggleFilled,
                        .toggleCircles,
                        .toggleCubic,
                        .toggleHorizontalCubic,
                        .toggleIcons,
                        .toggleStepped,
                        .toggleHighlight,
                        .toggleGradientLine,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData]



        labelDiagram.backgroundColor = .clear
        labelDiagram.textAlignment = .center
        labelDiagram.textColor = .white
        labelDiagram.text = NSLocalizedString("labelDiagram", comment: "")
        labelDiagram.font = labelDiagram.font.withSize(24)
        
        startDatePicker.timeZone = NSTimeZone.local
        startDatePicker.datePickerMode = .date
        startDatePicker.overrideUserInterfaceStyle = .dark
        startDatePicker.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        startDatePicker.setDate(.now, animated: true)
        startDatePicker.layerCornerRadius = 15
        startDatePicker.setValue(UIColor.white, forKey: "textColor")
        startDatePicker.addTarget(self, action: #selector(rangeOfDates), for: .valueChanged)
        startDatePicker.addTarget(self, action: #selector(self.curHistory), for: .valueChanged)
        
        endDatePicker.timeZone = NSTimeZone.local
        endDatePicker.datePickerMode = .date
        endDatePicker.overrideUserInterfaceStyle = .dark
        endDatePicker.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        endDatePicker.setDate(.now, animated: true)
        endDatePicker.layerCornerRadius = 15
        endDatePicker.setValue(UIColor.white, forKey: "textColor")
        endDatePicker.addTarget(self, action: #selector(rangeOfDates), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(self.curHistory), for: .valueChanged)
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        chartView.layer.cornerRadius = 5
        chartView.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#181B20")
        chartView.legendRenderer.legend = .none
        chartView.drawBordersEnabled = true
        chartView.borderColor = .gray
        chartView.legend.form = .line
    
        chartView.xAxis.gridLineDashPhase = 0
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.labelPosition = .bottom
        updateOfXAxis()

        chartView.leftAxis.labelTextColor = .white

        chartView.rightAxis.enabled = false

        sliderX.value = 45
        sliderY.value = 100
        chartView.animate(xAxisDuration: 2.5)
        
        outputLabel1.text = uploadCurToLabel(textOfLabel: &outputLabel1.text, currency: chosenCurShortName1)
        outputLabel1.text! += " 🟣"
        outputLabel1.textAlignment = .center
        outputLabel1.font = outputLabel1.font.withSize(14)
        outputLabel1.textColor = .white
        outputLabel1.backgroundColor = .clear
        
        outputCurButton1.layer.cornerRadius = 10
        outputCurButton1.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        outputCurButton1.setTitleColor(.white, for: .normal)
        outputCurButton1.addAction(UIAction { _ in
            let currencyScreen = CurrencyScreen()
            self.selectorDiagram = 1
            currencyScreen.delegateToConverterScreen = self
            Coordinator.openAnotherScreen(from: self, to: currencyScreen)
        }, for: .primaryActionTriggered)
        
        outputLabel2.text = uploadCurToLabel(textOfLabel: &outputLabel2.text, currency: chosenCurShortName2)
        outputLabel2.text! += " ⚪️"
        outputLabel2.textAlignment = .center
        outputLabel2.font = outputLabel1.font.withSize(14)
        outputLabel2.textColor = .white
        outputLabel2.backgroundColor = .clear
        
        outputCurButton2.layer.cornerRadius = 10
        outputCurButton2.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        outputCurButton2.setTitleColor(.white, for: .normal)
        outputCurButton2.addAction(UIAction { _ in
            let currencyScreen = CurrencyScreen()
            self.selectorDiagram = 2
            currencyScreen.delegateToConverterScreen = self
            Coordinator.openAnotherScreen(from: self, to: currencyScreen)
        }, for: .primaryActionTriggered)
        
        outputLabel3.text = uploadCurToLabel(textOfLabel: &outputLabel3.text, currency: chosenCurShortName3)
        outputLabel3.text! += " 🟠"
        outputLabel3.textAlignment = .center
        outputLabel3.font = outputLabel1.font.withSize(14)
        outputLabel3.textColor = .white
        outputLabel3.backgroundColor = .clear
        
        outputCurButton3.layer.cornerRadius = 10
        outputCurButton3.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        outputCurButton3.setTitleColor(.white, for: .normal)
        outputCurButton3.addAction(UIAction { _ in
            let currencyScreen = CurrencyScreen()
            self.selectorDiagram = 3
            currencyScreen.delegateToConverterScreen = self
            Coordinator.openAnotherScreen(from: self, to: currencyScreen)
        }, for: .primaryActionTriggered)
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(doSwipeRight(_:)))
        swipeRightGesture.direction = .right
        
        view.addSubview(diagramStackView)
        diagramStackView.addSubview(chartView)
        view.addSubview(labelDiagram)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        view.addGestureRecognizer(swipeRightGesture)
        
        view.addSubview(outputCurButton1)
        view.addSubview(outputCurButton2)
        view.addSubview(outputCurButton3)
        outputCurButton1.addSubview(outputLabel1)
        outputCurButton2.addSubview(outputLabel2)
        outputCurButton3.addSubview(outputLabel3)
        
        constraintsForDiagram()
    }
    
    // MARK: - Constraints
    func constraintsForDiagram() {
        diagramStackView.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(14)
            make.top.equalTo(view).inset(40)
            make.height.equalTo(590)
            make.width.equalTo(360)
        }
        
        chartView.snp.makeConstraints{ make in
            make.leading.equalTo(diagramStackView.snp.leading).inset(20)
            make.trailing.equalTo(diagramStackView.snp.trailing).inset(20)
            make.top.equalTo(diagramStackView.snp.top).inset(45)
            make.height.equalTo(540)
        }
        
        startDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(30)
            make.width.equalTo(128)
            make.height.equalTo(35)
            make.top.equalTo(diagramStackView.snp.top)
        }
        
        endDatePicker.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(30)
            make.width.equalTo(128)
            make.height.equalTo(35)
            make.top.equalTo(diagramStackView.snp.top)
        }
        
        outputCurButton1.snp.makeConstraints { make in
            make.width.equalTo(115)
            make.top.equalTo(diagramStackView.snp.bottom).offset(30)
            make.height.equalTo(28)
            make.leading.equalTo(view).inset(15)
        }
        
        outputLabel1.snp.makeConstraints { make in
            make.centerX.equalTo(outputCurButton1)
            make.centerY.equalTo(outputCurButton1)
        }
        
        outputCurButton2.snp.makeConstraints { make in
            make.width.equalTo(115)
            make.top.equalTo(diagramStackView.snp.bottom).offset(30)
            make.height.equalTo(28)
            make.leading.equalTo(view).inset(138)
        }
        
        outputLabel2.snp.makeConstraints { make in
            make.centerX.equalTo(outputCurButton2)
            make.centerY.equalTo(outputCurButton2)
        }
            
        outputCurButton3.snp.makeConstraints { make in
            make.width.equalTo(115)
            make.top.equalTo(diagramStackView.snp.bottom).offset(30)
            make.height.equalTo(28)
            make.leading.equalTo(view).inset(261)
        }
        
        outputLabel3.snp.makeConstraints { make in
            make.centerX.equalTo(outputCurButton3)
            make.centerY.equalTo(outputCurButton3)
        }
    }
    
    // MARK: - SwipeRight
    @objc private func doSwipeRight (_ gesture: UISwipeGestureRecognizer) {
        if gesture.state == .ended {
            Coordinator.closeAnotherScreen(from: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        diagramDelegate?.currenciesFromDiagramToConverter(curInput: chosenCurShortNameBase, curOutput1: chosenCurShortName1, curOutput2: chosenCurShortName2, curOutput3: chosenCurShortName3)
    }
    
    // MARK: - select start and end dates for range
    private var startChosenDates: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: startDatePicker.date)
    }
    private var endChosenDates: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: endDatePicker.date)
    }
    
    // MARK: - setting lines on diagram according to each currency
    func setData(coordinates: [ChartDataEntry], coordinates2: [ChartDataEntry], coordinates3: [ChartDataEntry], chosenCur1: String, chosenCur2: String, chosenCur3: String) {
        let set1 = LineChartDataSet(entries: coordinates, label: chosenCur1)
        let set2 = LineChartDataSet(entries: coordinates2, label: chosenCur2)
        let set3 = LineChartDataSet(entries: coordinates3, label: chosenCur3)
        
        setParameters(set: set1, value: 5, circleColor: NSUIColor.purple, drawValues: false, holeRadius: 0.0, lineColor: NSUIColor.purple)
        setParameters(set: set2, value: 5, circleColor: NSUIColor.white, drawValues: false, holeRadius: 0.0, lineColor: NSUIColor.white)
        setParameters(set: set3, value: 5, circleColor: NSUIColor.orange, drawValues: false, holeRadius: 0.0, lineColor: NSUIColor.orange)

        let data = LineChartData(dataSets: [set1, set2, set3]) // Passing an array of LineChartDataSet to LineChartData initializer
        
        chartView.data = data
    }
    
    func setParameters (set: LineChartDataSet, value: Int, circleColor: UIColor, drawValues: Bool, holeRadius: Float, lineColor: UIColor) {
        setCircleRadius(set: set, value: value)
        setCircleColor(set: set, color: circleColor)
        setCircleDrawValues(set: set, drawValues: drawValues)
        setCircleHoleRadius(set: set, holeRadius: holeRadius)
        setLineColor(set: set, lineColor: lineColor)
    }
    
    func setCircleRadius (set: LineChartDataSet, value: Int) {
        set.circleRadius = CGFloat(value)
    }
    func setCircleColor (set: LineChartDataSet, color: UIColor) {
        set.circleColors = [color]
    }
    func setCircleDrawValues (set: LineChartDataSet, drawValues: Bool) {
        set.drawValuesEnabled = drawValues
    }
    func setCircleHoleRadius(set: LineChartDataSet, holeRadius: Float) {
        set.circleHoleRadius = CGFloat(holeRadius)
    }
    func setLineColor (set: LineChartDataSet, lineColor: UIColor) {
        set.colors = [lineColor]
    }
    
    // MARK: - creation of date range on the base of selected start and end dates
    @objc func rangeOfDates() -> [String] {
        var arrayOfDates: [String] = []
        let dayDurationInSeconds: TimeInterval = 60*60*24
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        
        for date in stride(from: startDatePicker.date, to: endDatePicker.date, by: dayDurationInSeconds) {
            let tempStringDate = dateFormatter.string(from: date)
            arrayOfDates.append(tempStringDate)
        }
        return arrayOfDates
    }
    
    // MARK: - transfer of coordinates for diagram lines
    @objc func curHistory() {
        // check for selected based currency
        guard let chosenCurShortNameBase = chosenCurShortNameBase else {
            showAlertEmptyBasedCurrency()
            return
        }
            
        // api request for all rates during some period
        let stringUrl = "https://api.apilayer.com/fixer/timeseries?start_date=" + (startChosenDates) + "&end_date=" + (endChosenDates) + "&symbols=" + symbols() + "&base=" + (chosenCurShortNameBase)
        
        guard let url = URL(string: stringUrl) else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("mUGIIf6VCrvec8zDdJv2EofmA4euGt2z", forHTTPHeaderField: "apikey")
        
        guard let data = try? URLSession.shared.dataSync(with: request).0 else {
            return
        }
        rateData = RateData(from: data)
        
        updateOfXAxis()
        self.setData(coordinates: createCoordinates(chosenCurrentShortName: chosenCurShortName1), coordinates2: createCoordinates(chosenCurrentShortName: chosenCurShortName2), coordinates3: createCoordinates(chosenCurrentShortName: chosenCurShortName3), chosenCur1: chosenCurShortName1 ?? "", chosenCur2: chosenCurShortName2 ?? "", chosenCur3: chosenCurShortName3 ?? "")
    }
    // making string with all currencies for API request
    func symbols () -> String {
        var symbols = ""
        if let chosenCurShortName1 = chosenCurShortName1 {
            symbols += chosenCurShortName1
        }
        if let chosenCurShortName2 = chosenCurShortName2 {
            if symbols != "" {
                symbols += ","
            }
            symbols += chosenCurShortName2
        }
        if let chosenCurShortName3 = chosenCurShortName3 {
            if symbols != "" {
                symbols += ","
            }
            symbols += chosenCurShortName3
        }
        return symbols
    }
    func showAlertEmptyBasedCurrency () {
        let alertMissedCurBase = UIAlertController(title: "Missing based currency", message: "Please, select based currency", preferredStyle: .alert)
        let okActionBase = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertMissedCurBase.addAction(okActionBase)
        present(alertMissedCurBase, animated:  true, completion: nil)
    }
    
    // MARK: - Generate and set the new data
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        let data = self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
        chartView.data = data
    }
    func setDataCount(_ count: Int, range: UInt32) -> LineChartData {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val, icon: #imageLiteral(resourceName: "icon"))
        }

        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        set1.drawIconsEnabled = false
        setup(set1)

        let value = ChartDataEntry(x: Double(3), y: 3)
        set1.addEntryOrdered(value)
        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
                                ChartColorTemplates.colorFromString("#ffff0000").cgColor]
        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!

        set1.fillAlpha = 1
        set1.fill = LinearGradientFill(gradient: gradient, angle: 90)
        set1.drawFilledEnabled = true

        let data = LineChartData(dataSet: set1)
        return data
    }

    private func setup(_ dataSet: LineChartDataSet) {
        if dataSet.isDrawLineWithGradientEnabled {
            dataSet.lineDashLengths = nil
            dataSet.highlightLineDashLengths = nil
            dataSet.setColors(.black, .red, .white)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = [0, 40, 100]
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = nil
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        } else {
            dataSet.lineDashLengths = [5, 2.5]
            dataSet.highlightLineDashLengths = [5, 2.5]
            dataSet.setColor(.black)
            dataSet.setCircleColor(.black)
            dataSet.gradientPositions = nil
            dataSet.lineWidth = 1
            dataSet.circleRadius = 3
            dataSet.drawCircleHoleEnabled = false
            dataSet.valueFont = .systemFont(ofSize: 9)
            dataSet.formLineDashLengths = [5, 2.5]
            dataSet.formLineWidth = 1
            dataSet.formSize = 15
        }
    }

    override func optionTapped(_ option: Option) {
        guard let data = chartView.data else { return }
            switch option {
            case .toggleFilled:
                for case let set as LineChartDataSet in data {
                set.drawFilledEnabled = !set.drawFilledEnabled
            }
            chartView.setNeedsDisplay()

        case .toggleCircles:
            for case let set as LineChartDataSet in data {
                set.drawCirclesEnabled = !set.drawCirclesEnabled
            }
            chartView.setNeedsDisplay()

        case .toggleCubic:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
            }
            chartView.setNeedsDisplay()

        case .toggleStepped:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .stepped) ? .linear : .stepped
            }
            chartView.setNeedsDisplay()

        case .toggleHorizontalCubic:
            for case let set as LineChartDataSet in data {
                set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
            }
            chartView.setNeedsDisplay()
        case .toggleGradientLine:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.isDrawLineWithGradientEnabled = !set.isDrawLineWithGradientEnabled
                setup(set)
            }
            chartView.setNeedsDisplay()
        default:
            super.handleOption(option, forChartView: chartView)
        }
    }
    
    // MARK: - Prepare rates to coordinates type
    func createCoordinates (chosenCurrentShortName: String?) -> [ChartDataEntry] {
        guard let chosenCurShortName1 = chosenCurrentShortName else {
            return []
        }
        var x = -1
        let diagramData = (rateData?.rates.sorted(by: { dateAndRateLeft, dateAndRateRight in
            return dateAndRateLeft.key < dateAndRateRight.key
        }).compactMap { key, value in
            guard let currency = value[chosenCurShortName1] else {
                return nil as ChartDataEntry?
            }
            x += 1
            return ChartDataEntry(x: Double(x), y: currency)
        })
        return diagramData ?? []
    }
}

extension DiagramResult {
    private func updateOfXAxis() {
        self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: rangeOfDates())
        self.chartView.xAxis.labelCount = rangeOfDates().count
        self.chartView.xAxis.labelRotationAngle = -45 // Rotate the labels by -45 degrees to prevent overlapping
        self.chartView.xAxis.granularityEnabled = true
        self.chartView.xAxis.granularity = 1 // Ensure each label is drawn even if it overlaps with others
    }
    
    // MARK: - Update outputLabel's
    private func uploadCurToLabel ( textOfLabel: inout String?, currency: String?) -> String {
        let converter = ConverterScreen()
        if let currency = currency {
            let flagLabel = converter.getFlagToLabel(shortName: currency)
            return (flagLabel ?? "") + " " + currency
        } else {
            return "           "
        }
    }
}

extension DiagramResult: CurrencyScreenDelegate {
    // MARK: - set names and values of currencies by delegate
    func transferCurShortName(currency: String) {
        switch self.selectorDiagram {
        case 1: setCurLabels(label: &self.outputLabel1.text, currency: currency, curShortName: &self.chosenCurShortName1, color: " 🟣")
        case 2: setCurLabels(label: &self.outputLabel2.text, currency: currency, curShortName: &self.chosenCurShortName2, color: " ⚪️")
        case 3: setCurLabels(label: &self.outputLabel3.text, currency: currency, curShortName: &self.chosenCurShortName3, color: " 🟠")
        default: return
        }
        self.curHistory()
    }
    func setCurLabels(label: inout String?, currency: String, curShortName: inout String?, color: String) {
        let copyConverterScreen = ConverterScreen()
        
        curShortName = checkForEmptiness(currency: currency)
        
        var curShortNameFlag: String?
        if curShortName != nil {
            curShortNameFlag = copyConverterScreen.getFlagToLabel(shortName: curShortName!)
        }
        copyConverterScreen.convert()
        
        label = setLabelText(name: curShortName, flag: curShortNameFlag, color: color)
    }
    func checkForEmptiness(currency: String) -> String? {
        if currency == "" {
            return nil
        } else {
            return currency
        }
    }
    func setLabelText(name: String?, flag: String?, color: String) -> String {
        if name != nil {
            if flag != nil {
                return flag! + " " + name! + color
            } else {
                return "    " + name! + color
            }
        } else {
            return "          " + color
        }
    }
}
