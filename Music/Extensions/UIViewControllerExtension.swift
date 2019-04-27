import UIKit

extension UIViewController {

    /***/
    @objc func setupNavigationBar() { }

    /**
        Creates constraints for UIElements in the ViewController

        Parameters: None
     */
    @objc func addConstraints() { }

    /**
        Initialize and setup UIElements in the ViewController

        Parameters: None
     */
    @objc func setupView() { }

    var statusBarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.size.height
    }
}