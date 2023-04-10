//
// Created by Андрей Парамонов on 10.04.2023.
//

import Foundation

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol

    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }

    func viewDidLoad() {
        let request = authHelper.authRequest()
        CookieHelper.cleanAll()
        didUpdateProgressValue(0)
        view?.load(request: request)
    }

    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }

    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }

    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}