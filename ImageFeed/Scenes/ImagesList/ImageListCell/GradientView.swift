import UIKit

final class GradientView: UIView {

    var gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradient.frame = self.bounds
        layer.insertSublayer(gradient, at: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        colors: [CGColor],
        locations: [NSNumber]? = nil,
        startEnd: (CGPoint, CGPoint)? = nil
    ) {
        gradient.colors = colors

        if let locations {
            gradient.locations = locations
        }

        if let startEnd {
            gradient.startPoint = startEnd.0
            gradient.endPoint = startEnd.1
        }
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }
}

extension GradientView {
    func configureForLoader() {
        configure(
            colors: [
                UIColor(red: 0.431, green: 0.433, blue: 0.453, alpha: 1).cgColor,
                UIColor(red: 0.531, green: 0.533, blue: 0.553, alpha: 1).cgColor,
                UIColor(red: 0.682, green: 0.686, blue: 0.706, alpha: 1).cgColor
            ],
            locations: [0, 0, 0.25],
            startEnd: (
                CGPoint(x: 0, y: 0.5),
                CGPoint(x: 1, y: 0.5)
            )
        )
    }

    func animateLoader() {
        let gradientChangeAnimation = CABasicAnimation(keyPath: "locations")
        gradientChangeAnimation.duration = 1.0
        gradientChangeAnimation.autoreverses = true
        gradientChangeAnimation.repeatCount = .infinity
        gradientChangeAnimation.fromValue = [0, 0, 0.25]
        gradientChangeAnimation.toValue = [0, 0.75, 1]

        gradient.add(gradientChangeAnimation, forKey: "locationsChange")
    }

    func stopAnimationLoader() {
        gradient.removeAllAnimations()
    }
}
