//
//  ViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 20.01.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    private var HeartFillImage: UIImage!
    private var HeartImage: UIImage!
    private let photosName: [String] = (0..<20).map {
        "\($0)"
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        HeartFillImage = UIImage(named: "Heart.fill")
        HeartImage = UIImage(named: "Heart")
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }

}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        let imageCell = cell as? ImagesListCell ?? ImagesListCell()
        configCell(for: imageCell, with: indexPath)
        return imageCell
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        cell.ImageView.image = image
        cell.Label.text = dateFormatter.string(from: Date())
        let isFavorite = indexPath.row % 2 == 0
        let buttonImage = isFavorite ? HeartFillImage : HeartImage
        cell.FavoriteButton.setImage(buttonImage, for: .normal)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / image.size.width
        let imageViewHeight = image.size.height * scale
        return imageViewHeight + imageInsets.top + imageInsets.bottom
    }

}

extension ImagesListViewController: UITableViewDelegate {

}
