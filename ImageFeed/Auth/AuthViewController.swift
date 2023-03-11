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
        //TODO: process code
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
