//
//  ViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 20.01.2023.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .backgroundColor
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.separatorStyle = .none
        return tableView
    }()
    private let imagesListService = ImagesListService()
    private var photos: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        imageListServiceObserver = NotificationCenter.default
                .addObserver(forName: ImagesListService.DidChangeNotification,
                             object: nil,
                             queue: .main) { [weak self] _ in
                    self?.updateTableViewAnimated()
                }
        imagesListService.fetchPhotosNextPage()
    }

    private func setupView() {
        view.backgroundColor = .backgroundColor
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    tableView.topAnchor.constraint(equalTo: view.topAnchor),
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ]
        )
    }

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        let imageCell = cell as? ImagesListCell ?? ImagesListCell()
        configCell(for: imageCell, with: indexPath)
        return imageCell
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        cell.setImage(url: photo.thumbImageURL) { [weak self] in
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        cell.setDate(dateFormatter.string(from: photo.createdAt))
        cell.setIsLiked(photo.isLiked)
        cell.delegate = self
        cell.isUserInteractionEnabled = true
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return 0
//        }
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let scale = imageViewWidth / image.size.width
//        let imageViewHeight = image.size.height * scale
//        return imageViewHeight + imageInsets.top + imageInsets.bottom
//    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }

    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.images.count
        photos = imagesListService.images
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map {
                    IndexPath(row: $0, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in
            }
        }

    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let destination = SingleImageViewController()
        destination.setImage(url: photos[indexPath.row].largeImageURL)
        destination.modalPresentationStyle = .fullScreen
        present(destination, animated: true)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        UIBlockingProgressHUD.show()
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self, weak cell] result in
            defer {
                UIBlockingProgressHUD.dismiss()
            }
            switch result {
            case .success(let photo):
                self?.photos[indexPath.row] = photo
                cell?.setIsLiked(photo.isLiked)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
