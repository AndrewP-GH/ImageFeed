//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 22.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var FavoriteButton: UIButton!
    @IBOutlet var Label: UILabel!
}
