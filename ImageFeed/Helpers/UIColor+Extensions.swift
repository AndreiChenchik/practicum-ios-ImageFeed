import UIKit

extension UIColor {
    enum CustomColorAsset: String, CaseIterable {
        case background = "background"
    }

    convenience init(colorAsset: CustomColorAsset) {
        let color = UIColor(named: colorAsset.rawValue) ?? .clear
        self.init(cgColor: color.cgColor)
    }
}
