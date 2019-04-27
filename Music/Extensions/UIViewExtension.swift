import UIKit

extension UIView {

    /**
        Initialize and setup UIElements in the View

        Parameters: None
     */
    @objc func setupView() { }

    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}