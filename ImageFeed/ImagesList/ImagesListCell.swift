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
}
