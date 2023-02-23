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

    private var gradientLayer: CAGradientLayer? = nil

    func adjustDataGradientBackground() {
        if gradientLayer == nil {
            let colorTop = UIColor.ypBlack.withAlphaComponent(0).cgColor
            let colorBottom = UIColor.ypBlack.withAlphaComponent(0.8).cgColor
            let gradient = CAGradientLayer()
            gradient.colors = [colorTop, colorBottom]
            gradient.locations = [0.0, 1.0]
            dataView.layer.insertSublayer(gradient, at: 0)
            gradientLayer = gradient
        }
        gradientLayer!.frame = dataView.bounds
    }
}
