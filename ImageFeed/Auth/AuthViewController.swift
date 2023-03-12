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
            defer {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true)
                }
            }
            switch result {
            case .success(let token):
                print("Token: \(token)")
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
