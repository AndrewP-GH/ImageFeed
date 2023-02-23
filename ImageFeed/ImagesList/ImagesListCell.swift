//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 22.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var pictureView: UIImageView!
    @IBOutlet var addToFavoriteButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dataView: UIView!

    private var isGradientSet = false

    func setGradientBackground() {
        guard !isGradientSet else {
            return
        }
        let colorTop = UIColor.ypBlack.withAlphaComponent(0.0).cgColor
        let colorBottom = UIColor.ypBlack.withAlphaComponent(0.2).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
        isGradientSet = true
    }
}
