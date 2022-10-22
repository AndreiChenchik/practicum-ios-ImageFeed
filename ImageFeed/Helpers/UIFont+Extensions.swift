import UIKit

extension UIFont {
    static func asset(_ fontAsset: FontAsset, size: CGFloat) -> UIFont {
        let fallback = UIFont.systemFont(ofSize: size)
        let assetFont = UIFont(name: fontAsset.rawValue, size: size)

        return assetFont ?? fallback
    }
}
