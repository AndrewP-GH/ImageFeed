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

    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == loginSegueIdentifier {
            guard let vc = segue.destination as? WebViewViewController else {
                assertionFailure("Failed to prepare for segue \(loginSegueIdentifier)")
                return
            }
            vc.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
        dismiss(animated: true)
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
