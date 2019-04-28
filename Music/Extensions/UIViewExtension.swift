import UIKit

extension UIView {

    /**
        Initialize and setup UIElements in the View

        Parameters: None
     */
    @objc func setupView() { }

    /**
        Creates constraints for UIElements in the ViewController

        Parameters: None
     */
    @objc func addConstraints() { }

    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}