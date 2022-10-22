import UIKit

extension UIColor {
    enum CustomColorAsset: String, CaseIterable {
        case ypBlack
        case white
    }

    static func asset(_ colorAsset: CustomColorAsset) -> UIColor {
        UIColor(named: colorAsset.rawValue) ?? .clear
    }
}
