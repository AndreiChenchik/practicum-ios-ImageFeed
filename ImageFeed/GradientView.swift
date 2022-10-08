import UIKit

class GradientView: UIView {
    private let gradient = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradient.frame = self.bounds
        layer.insertSublayer(gradient, at: 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(colors: [CGColor], start: CGPoint, end: CGPoint) {
        gradient.colors = colors
        gradient.startPoint = start
        gradient.endPoint = end
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }
}
