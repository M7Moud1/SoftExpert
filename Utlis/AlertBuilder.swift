
import UIKit

class AlertBuilder {
    
    private var alertController: UIAlertController
    
    public init(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    }
    

    public func addAction(title: String = "", style: UIAlertAction.Style = .default, handler: @escaping (() -> ()) = { }) -> Self {
        alertController.addAction(UIAlertAction(title: title, style: style, handler: { _ in handler() }))
        return self
    }
    
    public func build() -> UIAlertController {
        return alertController
    }
}

public extension UIAlertController {
    func show(animated: Bool = true, completionHandler: (() -> ())? = nil) {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else {
            return
        }
        var forefrontVC = rootVC
        while let presentedVC = forefrontVC.presentedViewController {
            forefrontVC = presentedVC
        }
        forefrontVC.present(self, animated: animated, completion: completionHandler)
    }
}
