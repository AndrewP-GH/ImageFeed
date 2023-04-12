//
// Created by Андрей Парамонов on 11.04.2023.
//

import UIKit

protocol ImagesListPresenterProtocol {
    func viewDidLoad()
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func numberOfRows() -> Int
    func willDisplayCell(at indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func likeButtonTapped(at indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    private let imagesListService: ImagesListServiceProtocol
    private let dateFormatter: ImageDateFormatterProtocol
    weak var view: ImagesListViewControllerProtocol?
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private var fetchNext = true

    init(imagesListService: ImagesListServiceProtocol, dateFormatter: ImageDateFormatterProtocol) {
        self.imagesListService = imagesListService
        self.dateFormatter = dateFormatter
    }

    func viewDidLoad() {
        if imageListServiceObserver == nil {
            imageListServiceObserver = NotificationCenter.default
                    .addObserver(forName: ImagesListService.didChangeNotification,
                                 object: nil,
                                 queue: .main) { [weak self] _ in
                        self?.addRows()
                    }
        }
        fetchPhotosNextPage()
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        cell.setImage(url: photo.thumbImageURL) { [weak self] in
            self?.view?.reloadRows(at: [indexPath])
        }
        cell.setDate(dateFormatter.format(photo.createdAt))
        cell.setIsLiked(photo.isLiked)
        cell.delegate = view
        cell.isUserInteractionEnabled = true
    }

    func numberOfRows() -> Int {
        photos.count
    }

    func willDisplayCell(at indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            fetchPhotosNextPage()
        }
    }

    func didSelectRow(at indexPath: IndexPath) {
        let destination = SingleImageViewController()
        destination.setImage(url: photos[indexPath.row].largeImageURL)
        destination.modalPresentationStyle = .fullScreen
        view?.present(destination, animated: true)
    }

    func likeButtonTapped(at indexPath: IndexPath) {
        UIBlockingProgressHUD.show()
        let photo = photos[indexPath.row]
        imagesListService.changeLike(photoId: photo.id, isLike: photo.isLiked) { [weak self] result in
            switch result {
            case .success(let photo):
                self?.photos[indexPath.row] = photo
                self?.view?.reloadRows(at: [indexPath])
            case .failure(let error):
                debugPrint(error.localizedDescription)
                let alert = UIAlertController(title: "Error",
                                              message: error.localizedDescription,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self?.view?.present(alert, animated: true)
            }
        }
    }

    private func fetchPhotosNextPage() {
        guard fetchNext else {
            return
        }
        UIBlockingProgressHUD.show()
        imagesListService.fetchPhotosNextPage()
    }

    private func addRows() {
        UIBlockingProgressHUD.dismiss()
        let oldCount = photos.count
        let newCount = imagesListService.images.count
        photos = imagesListService.images
        if oldCount != newCount {
            let indexPaths = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            view?.insertRows(at: indexPaths)
        } else {
            fetchNext = false
        }
    }
}



