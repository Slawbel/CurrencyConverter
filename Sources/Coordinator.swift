import UIKit

class Coordinator {
    
    static func openAnotherScreen (from: UIViewController, to: UIViewController) {
        if let navigationController = from.navigationController {
            navigationController.pushViewController(to, animated: true)
        } else {
            to.modalPresentationStyle = .fullScreen
            from.present(to, animated: true)
        }
    }
    
    static func closeAnotherScreen (from: UIViewController) {
        if let navigationController = from.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            from.dismiss(animated: true)
        }
    }
}

