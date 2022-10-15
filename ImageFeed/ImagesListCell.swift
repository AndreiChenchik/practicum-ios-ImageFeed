import UIKit

class ImagesListCell: UITableViewCell {
    private let mainImageView: UIImageView
    private let dateLabel: UILabel
    private let isFavoriteView: UIImageView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        mainImageView = Self.getImageView()
        dateLabel = Self.getDateLabel()
        isFavoriteView = UIImageView()

        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        setupComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Cell configuration

extension ImagesListCell {
    func configure(with viewModel: ImageViewModel) {
        mainImageView.image = viewModel.image
        dateLabel.text = viewModel.dateString

        let isFavorite = UIImage(named: "isFavorite")
        let isNotFavorite = UIImage(named: "isNotFavorite")
        isFavoriteView.image = viewModel.isFavorite ? isFavorite : isNotFavorite

        layoutIfNeeded()
    }
}

// MARK: - Cell components

extension ImagesListCell {
    private static func getImageView() -> UIImageView {
        let imageView = UIImageView()

        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit

        return imageView
    }

    private static func getDateLabel() -> UILabel {
        let label = UILabel()

        let font = UIFont(name: "YSDisplay-Medium", size: 13)
        label.font = font
        label.textColor = .white

        return label
    }

    private func getGradient() -> GradientView {
        let view = GradientView()

        let colors = [
            UIColor.clear.cgColor,
            UIColor(colorAsset: .background).withAlphaComponent(0.9).cgColor
        ]

        let start = CGPointMake(0, 0)
        let end = CGPointMake(0, 0.5393)

        view.configure(colors: colors, start: start, end: end)
        return view
    }
}

// MARK: - Cell layout

extension ImagesListCell {
    private func setupComponents() {
        setupImageView()
        setupGradient()
        setupDataLabel()
        setupFavoriteView()
    }

    private func setupImageView() {
        mainImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainImageView)

        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: 4),
            mainImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
//            mainImageView.trailingAnchor.constraint(
//                equalTo: contentView.trailingAnchor, constant: -16),
            mainImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }

    private func setupGradient() {
        let gradientView = getGradient()
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        mainImageView.addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.leadingAnchor.constraint(
                equalTo: mainImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(
                equalTo: mainImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(
                equalTo: mainImageView.bottomAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func setupDataLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(
                equalTo: mainImageView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(
                equalTo: mainImageView.bottomAnchor, constant: -8)
        ])
    }

    private func setupFavoriteView() {
        isFavoriteView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(isFavoriteView)

        NSLayoutConstraint.activate([
            isFavoriteView.trailingAnchor.constraint(
                equalTo: mainImageView.trailingAnchor),
            isFavoriteView.topAnchor.constraint(
                equalTo: mainImageView.topAnchor),
            isFavoriteView.heightAnchor.constraint(equalToConstant: 42),
            isFavoriteView.widthAnchor.constraint(equalToConstant: 42)
        ])
    }
}
