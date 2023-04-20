import UIKit
import Charts
import SnapKit

class DiagramResult: UIViewController, ChartViewDelegate {
    lazy var lineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .white
        return chartView
    }()
    private let buttonBack = UIButton()
    
    private let example = [ChartDataEntry(x: 1, y: 2), ChartDataEntry(x: 2, y: 4), ChartDataEntry(x: 3, y: 9)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")
        
        
        
        buttonBack.backgroundColor = .darkGray
        buttonBack.setTitleColor(.white, for: .normal)
        let butBack = NSLocalizedString("butBack", comment: "")
        buttonBack.setTitle(butBack, for: .normal)
        
        setData()
        
        view.addSubview(lineChartView)
        view.addSubview(buttonBack)
        
        lineChartView.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(10)
            make.top.equalTo(view).inset(80)
            make.bottom.equalTo(view).inset(120)
        }
        
        buttonBack.snp.makeConstraints{ make in
            make.width.equalTo(200)
            make.centerX.equalTo(view)
            make.height.equalTo(80)
            make.bottom.equalTo(view).inset(20)
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData() {
        let set1 = LineChartDataSet(entries: example, label: "Result")
        let data = LineChartData(dataSet: set1)
        lineChartView.data = data
    }
    
}
