import UIKit

class DiagramPage: UIViewController {
    private let labelChooseCur = UILabel()
    private let buttonChosenCurBase = UIButton()
    private let labelChosenCurBase = UILabel()
    
    private let buttonChosenCur1 = UIButton()
    private let labelChosenCur1 = UILabel()
    
    private let buttonChosenCur2 = UIButton()
    private let labelChosenCur2 = UILabel()
    
    private let buttonChosenCur3 = UIButton()
    private let labelChosenCur3 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .init(named: "mainBackgroundColor")
        
        labelChooseCur.backgroundColor = .white
        labelChooseCur.textAlignment = .center
        labelChooseCur.text = NSLocalizedString("labelChooseCur", comment: "")
        
        buttonChosenCurBase.backgroundColor = .darkGray
        buttonChosenCurBase.setTitleColor(.white, for: .normal)
        let butChosecCurBase = NSLocalizedString("butChosenCurBase", comment: "")
        buttonChosenCurBase.setTitle(butChosecCurBase, for: .normal)
        
        labelChosenCurBase.backgroundColor = .white
        labelChosenCurBase.textAlignment = .center
        
        buttonChosenCur1.backgroundColor = .darkGray
        buttonChosenCur1.setTitleColor(.white, for: .normal)
        let butChosecCur1 = NSLocalizedString("butChosenCur1", comment: "")
        buttonChosenCur1.setTitle(butChosecCur1, for: .normal)
        
        labelChosenCur1.backgroundColor = .white
        labelChosenCur1.textAlignment = .center
        
        buttonChosenCur2.backgroundColor = .darkGray
        buttonChosenCur2.setTitleColor(.white, for: .normal)
        let butChosecCur2 = NSLocalizedString("butChosenCur2", comment: "")
        buttonChosenCur2.setTitle(butChosecCur2, for: .normal)
        
        labelChosenCur2.backgroundColor = .white
        labelChosenCur2.textAlignment = .center
        
        buttonChosenCur3.backgroundColor = .darkGray
        buttonChosenCur3.setTitleColor(.white, for: .normal)
        let butChosecCur3 = NSLocalizedString("butChosenCur3", comment: "")
        buttonChosenCur3.setTitle(butChosecCur3, for: .normal)
        
        labelChosenCur3.backgroundColor = .white
        labelChosenCur3.textAlignment = .center
        
        view.addSubview(labelChooseCur)
        view.addSubview(buttonChosenCurBase)
        view.addSubview(labelChosenCurBase)
        view.addSubview(buttonChosenCur1)
        view.addSubview(labelChosenCur1)
        view.addSubview(buttonChosenCur2)
        view.addSubview(labelChosenCur2)
        view.addSubview(buttonChosenCur3)
        view.addSubview(labelChosenCur3)
        
        
        labelChooseCur.snp.makeConstraints{ make in
            make.leading.trailing.equalTo(view).inset(0)
            make.top.equalTo(view).inset(40)
            make.height.equalTo(60)
        }
        
        buttonChosenCurBase.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(0)
            make.width.equalTo(200)
            make.top.equalTo(view).inset(105)
            make.height.equalTo(60)
        }
        
        labelChosenCurBase.snp.makeConstraints{ make in
            make.trailing.equalTo(view).inset(0)
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(105)
            make.height.equalTo(60)
        }
        
        buttonChosenCur1.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(0)
            make.width.equalTo(200)
            make.top.equalTo(view).inset(200)
            make.height.equalTo(60)
        }
        
        labelChosenCur1.snp.makeConstraints{ make in
            make.trailing.equalTo(view).inset(0)
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(200)
            make.height.equalTo(60)
        }
        
        buttonChosenCur2.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(0)
            make.width.equalTo(200)
            make.top.equalTo(view).inset(270)
            make.height.equalTo(60)
        }
        
        labelChosenCur2.snp.makeConstraints{ make in
            make.trailing.equalTo(view).inset(0)
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(270)
            make.height.equalTo(60)
        }
        
        buttonChosenCur3.snp.makeConstraints{ make in
            make.leading.equalTo(view).inset(0)
            make.width.equalTo(200)
            make.top.equalTo(view).inset(340)
            make.height.equalTo(60)
        }
        
        labelChosenCur3.snp.makeConstraints{ make in
            make.trailing.equalTo(view).inset(0)
            make.leading.equalTo(view).inset(205)
            make.top.equalTo(view).inset(340)
            make.height.equalTo(60)
        }
        
    }
}
