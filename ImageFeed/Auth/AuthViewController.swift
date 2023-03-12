//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 10.03.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    @IBOutlet private var loginButton: UIButton!

    private let loginSegueIdentifier = "ShowWebView"

    private let authService = OAuth2Service()
    private let tokenStorage = OAuth2TokenStorage()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginSegueIdentifier {
            guard let vc = segue.destination as? WebViewViewController else {
                fatalError("Failed to prepare for segue \(loginSegueIdentifier)")
            }
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        authService.fetchAuthToken(code: code) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                switch result {
                case .success(let token):
                    self.tokenStorage.token = token
                    self.dismiss(animated: true)
                case .failure(let error):
                    let alert = UIAlertController(
                            title: "Authorize error",
                            message: error.localizedDescription,
                            preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) {
                        [weak self] _ in
                        self?.dismiss(animated: true)
                    })
                    vc.present(alert, animated: true)
                }
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
