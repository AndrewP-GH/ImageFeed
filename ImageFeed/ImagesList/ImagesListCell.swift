//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 22.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private lazy var pictureView: UIImageView = {
        let pictureView = UIImageView()
        pictureView.translatesAutoresizingMaskIntoConstraints = false
        pictureView.contentMode = .scaleAspectFill
        pictureView.layer.cornerRadius = 16
        pictureView.clipsToBounds = true
        pictureView.backgroundColor = .clear
        return pictureView
    }()
    private lazy var addToFavoriteButton: UIButton = {
        let addToFavoriteButton = UIButton(type: .custom)
        addToFavoriteButton.translatesAutoresizingMaskIntoConstraints = false
        addToFavoriteButton.setImage(heartImage, for: .normal)
        return addToFavoriteButton
    }()
    private lazy var gradientView: GradientView = {
        let gradientView = GradientView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        return gradientView
    }()
    private lazy var dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = .ypWhite
        dateLabel.textAlignment = .left
        dateLabel.text = "27 августа 2022"
        return dateLabel
    }()
    private lazy var heartImage: UIImage = {
        UIImage(named: "Heart")!
    }()
    private lazy var heartFillImage: UIImage = {
        UIImage(named: "Heart.fill")!
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    func setImage(url: URL, completion: @escaping () -> Void) {
        pictureView.kf.indicatorType = .activity
        pictureView.kf.setImage(with: url) { [weak self] result in
            switch result {
            case .success(let value):
                guard let self else {
                    return
                }
                completion()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }

    func setDate(_ date: String) {
        dateLabel.text = date
    }

    func setFavorite(_ isFavorite: Bool) {
        addToFavoriteButton.setImage(isFavorite ? heartFillImage : heartImage, for: .normal)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pictureView.kf.cancelDownloadTask()
    }

    private func setupView() {
        backgroundColor = .backgroundColor
        selectionStyle = .none
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        contentView.addSubview(pictureView)
        pictureView.addSubview(addToFavoriteButton)
        pictureView.addSubview(gradientView)
        gradientView.addSubview(dateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    // pictureView
                    pictureView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
                    pictureView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                    pictureView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                    pictureView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
                    // addToFavoriteButton
                    addToFavoriteButton.topAnchor.constraint(equalTo: pictureView.topAnchor, constant: 12),
                    addToFavoriteButton.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor, constant: -10),
                    // gradientView
                    gradientView.heightAnchor.constraint(equalToConstant: 40),
                    gradientView.leadingAnchor.constraint(equalTo: pictureView.leadingAnchor),
                    gradientView.trailingAnchor.constraint(equalTo: pictureView.trailingAnchor),
                    gradientView.bottomAnchor.constraint(equalTo: pictureView.bottomAnchor),
                    // dateLabel
                    dateLabel.topAnchor.constraint(equalTo: gradientView.topAnchor, constant: 4),
                    dateLabel.leadingAnchor.constraint(equalTo: gradientView.leadingAnchor, constant: 8),
                    dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: gradientView.trailingAnchor, constant: -8),
                    dateLabel.bottomAnchor.constraint(equalTo: gradientView.bottomAnchor, constant: -8)
                ]
        )
    }
}
