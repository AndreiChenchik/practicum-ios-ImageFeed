import UIKit

extension UIImage {
    static func asset(_ imageAsset: ImageAsset) -> UIImage {
        guard let image = UIImage(named: imageAsset.rawValue) else {
            preconditionFailure("Can't find \(imageAsset.rawValue)")
        }

        return image
    }
}
