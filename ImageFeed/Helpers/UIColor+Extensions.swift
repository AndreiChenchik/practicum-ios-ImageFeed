import UIKit

extension UIColor {
    static func asset(_ colorAsset: CustomColorAsset) -> UIColor {
        UIColor(named: colorAsset.rawValue) ?? .clear
    }
}
