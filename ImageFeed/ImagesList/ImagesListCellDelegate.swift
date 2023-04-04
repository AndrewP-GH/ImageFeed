//
// Created by Андрей Парамонов on 04.04.2023.
//

import Foundation

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
