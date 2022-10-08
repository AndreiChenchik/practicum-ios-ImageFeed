import UIKit

class ImagesListCell: UITableViewCell {
    let mainImageView = UIImageView()
    let dateLabel = UILabel()
    let isFavoriteView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()

        mainImageView.layer.cornerRadius = 16
        mainImageView.clipsToBounds = true

        contentView.addSubview(mainImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(isFavoriteView)

        NSLayoutConstraint.activate([
            mainImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor),
            mainImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor),
            mainImageView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor)
        ])
    }

    func configure(with viewModel: ImageViewModel) {
        mainImageView.image = viewModel.image
        dateLabel.text = viewModel.date.description
        let icon = viewModel.isFavorite ? "heart.fill" : "heart"
        isFavoriteView.image = viewModel.image
    }
}
