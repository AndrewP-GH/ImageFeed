//
// Created by Андрей Парамонов on 12.04.2023.
//

import Foundation

protocol ImageDateFormatterProtocol {
    func formatDate(_ date: Date?) -> String
}

final class ImageDateFormatter: ImageDateFormatterProtocol {
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    func formatDate(_ date: Date?) -> String {
        var formattedDate = ""
        if let date = date {
            formattedDate = dateFormatter.string(from: date)
        }
        return formattedDate
    }
}
