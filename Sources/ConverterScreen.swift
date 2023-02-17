import UIKit
import SnapKit

class ConverterScreen: UIViewController {
    private let inputCurButton = UIButton()
    private let inputCurLabel = UILabel()
    private let inputTF = UITextField()
    private let swapButton = UIButton()
    private let outputCurButton = UIButton()
    private let outputCurLabel = UILabel()
    private let buttonCalc = UIButton()
    private let outputLabel = UILabel()
    private let buttonDiagram = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
		view.backgroundColor = .init(named: "mainBackgroundColor")
        
        inputCurButton.backgroundColor = .white
        inputCurButton.setTitleColor(.black, for: .normal)
        let inputCurBut = NSLocalizedString("inputCurBut", comment: "")
        inputCurButton.setTitle(inputCurBut, for: .normal)
        
        
        inputCurLabel.textAlignment = .center
        inputCurLabel.backgroundColor = .white
        
        inputTF.placeholder = NSLocalizedString("writeTheAmount", comment: "")
        inputTF.textAlignment = .center
        inputTF.backgroundColor = .white
        
        swapButton.backgroundColor = .white
        swapButton.setTitleColor(.black, for: .normal)
        let swap = NSLocalizedString("swap", comment: "")
        swapButton.setTitle(swap, for: .normal)
    
        buttonCalc.backgroundColor = .white
        buttonCalc.setTitleColor(.black, for: .normal)
        let calc = NSLocalizedString("convert", comment: "")
        buttonCalc.setTitle(calc, for: .normal)
        
        outputCurButton.backgroundColor = .white
        outputCurButton.setTitleColor(.black, for: .normal)
        let outputCurBut = NSLocalizedString("outputCurBut", comment: "")
        outputCurButton.setTitle(outputCurBut, for: .normal)
        
        
        outputCurLabel.textAlignment = .center
        outputCurLabel.backgroundColor = .white
        
        outputLabel.textAlignment = .center
        outputLabel.backgroundColor = .white
        
        buttonDiagram.backgroundColor = .white
        buttonDiagram.setTitleColor(.black, for: .normal)
        let buttonDiagramText = NSLocalizedString("transfer", comment: "")
        buttonDiagram.setTitle(buttonDiagramText, for: .normal)
        
        view.addSubview(inputCurButton)
        view.addSubview(inputCurLabel)
        view.addSubview(inputTF)
        view.addSubview(swapButton)
        view.addSubview(outputCurButton)
        view.addSubview(outputCurLabel)
        view.addSubview(buttonCalc)
        view.addSubview(outputLabel)
        view.addSubview(buttonDiagram)
        
        
        inputCurButton.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(70)
            make.top.equalTo(view).inset(80)
            make.height.equalTo(50)
        }
        
        inputCurLabel.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(70)
            make.top.equalTo(view).inset(140)
            make.height.equalTo(40)
        }
        
        inputTF.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(70)
            make.top.equalTo(view).inset(190)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
        }
        
        swapButton.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(260)
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        outputCurButton.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(70)
            make.top.equalTo(view).inset(340)
            make.height.equalTo(50)
        }
        
        outputCurLabel.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(70)
            make.top.equalTo(view).inset(400)
            make.height.equalTo(40)
        }
        
        
        buttonCalc.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(460)
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
        outputLabel.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(530)
            make.leading.trailing.equalTo(view).inset(70)
            make.height.equalTo(40)
        }
        
        buttonDiagram.snp.makeConstraints{ make in
            make.top.equalTo(view).inset(600)
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(50)
        }
        
    }
}
