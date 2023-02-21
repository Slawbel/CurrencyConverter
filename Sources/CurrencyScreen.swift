import SnapKit
import UIKit

class CurrencyScreen: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView(frame: .init(x: 50, y: 80, width: 290, height: 550), style: .plain)
    private let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewController = UIViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)

        backButton.backgroundColor = .white
        backButton.setTitleColor(.black, for: .normal)
        let buttonBack = NSLocalizedString("buttonBack", comment: "")
        backButton.setTitle(buttonBack, for: .normal)

        view.addSubview(tableView)
        view.addSubview(backButton)

        backButton.snp.makeConstraints { make in
            make.top.equalTo(view).inset(650)
            make.centerX.equalTo(view)
            make.width.equalTo(120)
            make.height.equalTo(50)

            backButton.addAction(UIAction { [weak self] _ in
                self?.dismiss(animated: true)
            }, for: .primaryActionTriggered)
        }
    }

    func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as? MyTableViewCell
        return cell!
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        40
    }

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {}
}
