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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")
        
        
        
        buttonBack.backgroundColor = .darkGray
        buttonBack.setTitleColor(.white, for: .normal)
        let butBack = NSLocalizedString("butBack", comment: "")
        buttonBack.setTitle(butBack, for: .normal)
        buttonBack.addAction(.init { [unowned self] _ in
            dismiss(animated: true)
        }, for: .primaryActionTriggered)
        
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
    
    func setData(coordinates: [ChartDataEntry], coordinates2 : [ChartDataEntry], coordinates3: [ChartDataEntry], chosenCur1: String, chosenCur2: String, chosenCur3: String) {
        let set1 = LineChartDataSet(entries: coordinates, label: chosenCur1)
        let set2 = LineChartDataSet(entries: coordinates2, label: chosenCur2)
        let set3 = LineChartDataSet(entries: coordinates3, label: chosenCur3)
        set1.colors = [NSUIColor.blue]
        set2.colors = [NSUIColor.red]
        set3.colors = [NSUIColor.black]
        let data = LineChartData(dataSets: [set1, set2, set3])
        lineChartView.data = data
    }
    
}
