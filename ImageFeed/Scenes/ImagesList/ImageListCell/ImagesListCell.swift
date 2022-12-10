import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(
        _ cell: ImagesListCell,
        completion: @escaping (Bool) -> Void
    )
}

final class ImagesListCell: UITableViewCell {

    weak var delegate: ImagesListCellDelegate?

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

    private let isFavoriteButton: UIButton = {
        let button = UIButton()
        return UIButton()
    }()
}

// MARK: - Cell configuration

extension ImagesListCell {
    func configure(with viewModel: ImageViewModel) {
        mainImageView.kf.indicatorType = .activity
        mainImageView.kf.setImage(with: viewModel.image, placeholder: UIImage.asset(.placeholderImageCell))

        dateLabel.text = viewModel.dateString

        setIsLiked(viewModel.isFavorite)

        layoutIfNeeded()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        setIsLiked(false)
        mainImageView.kf.cancelDownloadTask()
    }
}

// MARK: - Cell layout

extension ImagesListCell {
    private func setupComponents() {
        setupImageView()
        setupGradient()
        setupDataLabel()
        setupFavoriteButton()
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
}

// MARK: - Favorite Button

extension ImagesListCell {
    private func setupFavoriteButton() {
        isFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(isFavoriteButton)

        NSLayoutConstraint.activate([
            isFavoriteButton.trailingAnchor.constraint(
                equalTo: mainImageView.trailingAnchor),
            isFavoriteButton.topAnchor.constraint(
                equalTo: mainImageView.topAnchor),
            isFavoriteButton.heightAnchor.constraint(equalToConstant: 42),
            isFavoriteButton.widthAnchor.constraint(equalToConstant: 42)
        ])

        isFavoriteButton.addTarget(self,
                                   action: #selector(favoriteButtonPressed),
                                   for: .touchUpInside)
    }

    private func setIsLiked(_ state: Bool) {
        isFavoriteButton.setBackgroundImage(
            state
            ? .asset(.isFavoriteIcon)
            : .asset(.isNotFavoriteIcon),
            for: .normal
        )
    }

    @objc func favoriteButtonPressed() {
        delegate?.imageListCellDidTapLike(self) { [weak self] in
            self?.setIsLiked($0)
        }
    }
}
