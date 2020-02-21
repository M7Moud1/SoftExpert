

import UIKit
import MBProgressHUD

class UIViewHelper {
    
    static let shared = UIViewHelper()

    
    func hideActivityIndicator(uiView: UIView?, instantly : Bool = false) {
        guard let uiView = uiView else { return }
        for subview in uiView.subviews where subview.restorationIdentifier == "activityIndicator" {
            guard let hud = subview as? MBProgressHUD else { return }
            if instantly {
                hud.hide(animated: false)
            } else {
                hud.hide(animated: true)
            }
        }
    }
    
    func showActivityIndicator(uiView : UIView?) {
        guard let uiView = uiView else { return }
        let hud = MBProgressHUD.showAdded(to: uiView, animated: false)
        hud.mode = .indeterminate
        hud.backgroundView.style = .solidColor
        hud.backgroundView.color = UIColor.black.withAlphaComponent(0.3)
        hud.bezelView.backgroundColor = UIColor.lightGray
        hud.bezelView.isOpaque = false
        hud.bezelView.layer.cornerRadius = 10
        hud.contentColor = .gray
        hud.restorationIdentifier = "activityIndicator"
    }

}
