import UIKit

class Coordinator {
    
    static func openCurrencyScreen (from: UIViewController, to: UIViewController) {
        to.modalPresentationStyle = .fullScreen
        from.navigationController?.pushViewController(to, animated: true)
    }
}
