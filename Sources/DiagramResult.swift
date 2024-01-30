import UIKit
import DGCharts
import SnapKit

protocol ConverterScreenDelegate: AnyObject {
    func transferedCurNames(basicCur: String, firstCur: String, secondCur: String, thirdCur: String?)
}

class DiagramResult: DemoBaseViewController {
    
    private let diagramStackView = UIStackView()
    
    var chartView = LineChartView()
    var sliderX = UISlider()
    var sliderY = UISlider()
    var sliderTextX = UITextField()
    var sliderTextY = UITextField()
    
    var chosenCurShortNameBase: String?
    var chosenCurShortName1: String?
    var chosenCurShortName2: String?
    var chosenCurShortName3: String?
    
    private let labelDiagram = UILabel()
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()

    private var rateData: RateData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")
        
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

        chartView.delegate = self


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
        //startDatePicker.addTarget(self, action: #selector(rangeOfDates), for: .valueChanged)
        //startDatePicker.addTarget(self, action: #selector(self.curHistory), for: .valueChanged)
        
        endDatePicker.timeZone = NSTimeZone.local
        endDatePicker.datePickerMode = .date
        endDatePicker.overrideUserInterfaceStyle = .dark
        endDatePicker.backgroundColor = SetColorByCode.hexStringToUIColor(hex: "#2B333A")
        endDatePicker.setDate(.now, animated: true)
        endDatePicker.layerCornerRadius = 15
        endDatePicker.setValue(UIColor.white, forKey: "textColor")
        //endDatePicker.addTarget(self, action: #selector(rangeOfDates), for: .valueChanged)
        //endDatePicker.addTarget(self, action: #selector(self.curHistory), for: .valueChanged)
        
        chartView.chartDescription.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
    
        // x-axis limit line
        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        llXAxis.lineWidth = 4
        llXAxis.lineDashLengths = [10, 10, 0]
        llXAxis.labelPosition = .rightBottom
        llXAxis.valueFont = .systemFont(ofSize: 10)

        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        let ll1 = ChartLimitLine(limit: 150, label: "Upper Limit")
        ll1.lineWidth = 4
        ll1.lineDashLengths = [5, 5]
        ll1.labelPosition = .rightTop
        ll1.valueFont = .systemFont(ofSize: 10)

        let ll2 = ChartLimitLine(limit: -30, label: "Lower Limit")
        ll2.lineWidth = 4
        ll2.lineDashLengths = [5,5]
        ll2.labelPosition = .rightBottom
        ll2.valueFont = .systemFont(ofSize: 10)

        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.addLimitLine(ll1)
        leftAxis.addLimitLine(ll2)
        leftAxis.axisMaximum = 200
        leftAxis.axisMinimum = -50
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        
        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
              //[_chartView.viewPortHandler setMaximumScaleX: 2.f];

        chartView.legend.form = .line

        sliderX.value = 45
        sliderY.value = 100

        chartView.animate(xAxisDuration: 2.5)


        view.addSubview(diagramStackView)
        diagramStackView.addSubview(chartView)
        view.addSubview(labelDiagram)
        view.addSubview(startDatePicker)
        view.addSubview(endDatePicker)
        
        diagramStackView.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(14)
            make.top.equalTo(view).inset(164)
            make.height.equalTo(590)
            make.width.equalTo(360)
        }
        
        chartView.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(28)
            make.top.equalTo(view).inset(190)
            make.height.equalTo(540)
        }
        
        labelDiagram.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(148)
            make.top.equalTo(view).inset(58)
            make.height.equalTo(40)
            make.width.equalTo(95)
        }
        
        startDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(19)
            make.width.equalTo(128)
            make.height.equalTo(35)
            make.top.equalTo(view).inset(115)
        }
        
        endDatePicker.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(154)
            make.width.equalTo(128)
            make.height.equalTo(35)
            make.top.equalTo(view).inset(115)
        }
    }
    
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
    
    @objc func rangeOfDates() -> [String] {
        var arrayOfDates: [String] = []
        let dayDurationInSeconds: TimeInterval = 60*60*24
        for date in stride(from: startDatePicker.date, to: endDatePicker.date, by: dayDurationInSeconds) {
            let tempStringDate = changeDateFormat(dateForChange: date)
            arrayOfDates.append(tempStringDate)
        }
        print(arrayOfDates)
        return arrayOfDates
    }
    
    func changeDateFormat (dateForChange: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: dateForChange)
        return stringDate
    }
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }

        self.setDataCount(Int(sliderX.value), range: UInt32(sliderY.value))
    }

    func setDataCount(_ count: Int, range: UInt32) {
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

        chartView.data = data
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
}

extension DiagramResult: ConverterScreenDelegate {
    func transferedCurNames(basicCur: String, firstCur: String, secondCur: String, thirdCur: String?) {
        self.chosenCurShortNameBase = basicCur
        self.chosenCurShortName1 = firstCur
        self.chosenCurShortName2 = secondCur
        self.chosenCurShortName3 = thirdCur
    }
}






