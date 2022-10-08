import UIKit

class ImagesListCell: UITableViewCell {
    let mainImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let dateLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 20)
        label.textColor = .white

        label.text = "test"

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let isFavoriteView: UIImageView = {
        let imageView = UIImageView()

        let configuration = UIImage.SymbolConfiguration(
            font: .systemFont(ofSize: 20))

        imageView.image = UIImage(
            systemName: "heart.fill", withConfiguration: configuration)

        imageView.tintColor = .white.withAlphaComponent(0.1)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let gradientView: GradientView = {
        let view = GradientView()

        let colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor
        ]

        let start = CGPointMake(0, 0)
        let end = CGPointMake(0, 0.5393)

        view.configure(colors: colors, start: start, end: end)

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear

        contentView.addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            mainImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor),
            mainImageView.heightAnchor.constraint(equalToConstant: 200)
        ])

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

        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(
                equalTo: mainImageView.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(
                equalTo: mainImageView.bottomAnchor, constant: -8)
        ])

        contentView.addSubview(isFavoriteView)
        NSLayoutConstraint.activate([
            isFavoriteView.trailingAnchor.constraint(
                equalTo: mainImageView.trailingAnchor, constant: -10.5),
            isFavoriteView.topAnchor.constraint(
                equalTo: mainImageView.topAnchor, constant: 12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with viewModel: ImageViewModel) {
        mainImageView.image = viewModel.image
        dateLabel.text = viewModel.date.description

        let onColor = UIColor.systemPink
        let offColor = UIColor.white.withAlphaComponent(0.1)
        isFavoriteView.tintColor = viewModel.isFavorite ? onColor : offColor
    }
}
