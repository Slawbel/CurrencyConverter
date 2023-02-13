import UIKit
import SnapKit

class ConverterScreen: UIViewController {
    private let inputTF = UITextField()
    private let swapButton = UIButton()
    private let buttonCalc = UIButton()
    private let outputLabel = UILabel()
    private let buttonDiagram = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .init(named: "mainBackgroundColor")
        inputTF.placeholder = NSLocalizedString("writeTheAmount", comment: "")
        inputTF.textAlignment = .center
        inputTF.backgroundColor = .white
        
        
        swapButton.backgroundColor = .white
        swapButton.setTitleColor(.black, for: .normal)
        let swap = NSLocalizedString("swap", comment: "")
        swapButton.setTitle(swap, for: .normal)
    
        buttonCalc.backgroundColor = .white
        buttonCalc.setTitleColor(.black, for: .normal)
        let Calc = NSLocalizedString("convert", comment: "")
        buttonCalc.setTitle(Calc, for: .normal)
        
        outputLabel.textAlignment = .center
        outputLabel.backgroundColor = .white
        
        buttonDiagram.backgroundColor = .white
        buttonDiagram.setTitleColor(.black, for: .normal)
        let buttonDiagramText = NSLocalizedString("transfer", comment: "")
        buttonDiagram.setTitle(buttonDiagramText, for: .normal)
        
        
        view.addSubview(inputTF)
        view.addSubview(swapButton)
        view.addSubview(buttonCalc)
        view.addSubview(outputLabel)
        view.addSubview(buttonDiagram)
        
        
        inputTF.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(70)
            make.top.equalTo(view).inset(160)
            make.centerX.equalTo(view)
        }
        
        swapButton.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(210)
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        buttonCalc.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(470)
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        outputLabel.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(380)
            make.centerX.equalTo(view)
            make.leading.trailing.equalTo(view).inset(70)
            make.height.equalTo(50)
        }
        
        buttonDiagram.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(550)
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
    }
}
