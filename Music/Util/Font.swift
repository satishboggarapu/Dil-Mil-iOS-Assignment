import UIKit

public struct Font {

    public struct Futura {

        public static func medium(with size: CGFloat) -> UIFont {
            if let f = UIFont(name: "Futura-Medium", size: size) {
                return f
            }
            return UIFont.systemFont(ofSize: size)
        }

        public static func regular(with size: CGFloat) -> UIFont {
            if let f = UIFont(name: "Futura-Regular", size: size) {
                return f
            }
            return UIFont.systemFont(ofSize: size)
        }
    }
}