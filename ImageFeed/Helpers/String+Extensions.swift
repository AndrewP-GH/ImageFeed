//
// Created by Андрей Парамонов on 18.03.2023.
//

import Foundation

extension String? {
    func orEmpty() -> String {
        self ?? ""
    }
}