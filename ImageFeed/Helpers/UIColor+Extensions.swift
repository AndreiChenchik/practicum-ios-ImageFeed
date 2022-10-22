import UIKit

extension UIColor {
    static func asset(_ colorAsset: ColorAsset) -> UIColor {
        UIColor(named: colorAsset.rawValue) ?? .clear
    }
}
