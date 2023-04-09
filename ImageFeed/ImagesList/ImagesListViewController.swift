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
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    private let imagesListService = ImagesListService()
    private var photos: [Photo] = []
    private var imageListServiceObserver: NSObjectProtocol?
    private var fetchNext = true

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        imageListServiceObserver = NotificationCenter.default
                .addObserver(forName: ImagesListService.didChangeNotification,
                             object: nil,
                             queue: .main) { [weak self] _ in
                    self?.updateTableViewAnimated()
                }
        fetchPhotosNextPage()
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

        cell.setDate(formatCreationDate(photo.createdAt))
        cell.setIsLiked(photo.isLiked)
        cell.delegate = self
        cell.isUserInteractionEnabled = true
    }

    private func formatCreationDate(_ createdAt: Date?) -> String {
        var formattedDate = ""
        if let date = createdAt {
            formattedDate = dateFormatter.string(from: date)
        }
        return formattedDate
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            fetchPhotosNextPage()
        }
    }

    private func updateTableViewAnimated() {
        UIBlockingProgressHUD.dismiss()
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
        } else {
            fetchNext = false
        }
    }

    private func fetchPhotosNextPage() {
        guard fetchNext else {
            return
        }
        UIBlockingProgressHUD.show()
        imagesListService.fetchPhotosNextPage()
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
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let photo):
                self.photos[indexPath.row] = photo
                cell.setIsLiked(photo.isLiked)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
    }
}
