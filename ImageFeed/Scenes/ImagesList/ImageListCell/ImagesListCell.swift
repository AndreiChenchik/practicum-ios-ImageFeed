import UIKit

class ImagesListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none

        setupComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Cell components

    private let mainImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        return imageView
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.font = .asset(.ysDisplayRegular, size: 13)
        label.textColor = .asset(.ypWhite)

        return label
    }()

    private let gradientView: GradientView = {
        let view = GradientView()

        let colors: [CGColor] = [
            UIColor.asset(.ypBlack).withAlphaComponent(0).cgColor,
            UIColor.asset(.ypBlack).withAlphaComponent(0.2).cgColor
        ]

        let locations: [NSNumber] = [0, 0.5393]

        view.configure(colors: colors, locations: locations)
        return view
    }()

    private let isFavoriteView = UIImageView()
}

// MARK: - Cell configuration

extension ImagesListCell {
    func configure(with viewModel: ImageViewModel) {
        mainImageView.image = viewModel.image
        dateLabel.text = viewModel.dateString

        isFavoriteView.image = viewModel.isFavorite
            ? .asset(.isFavoriteIcon)
            : .asset(.isNotFavoriteIcon)

        layoutIfNeeded()
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
                equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            mainImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            mainImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }

    private func setupGradient() {
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
