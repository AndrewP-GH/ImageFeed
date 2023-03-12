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
        let request = createAuthRequest(code: code)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            defer {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true)
                }
            }
            if let data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                let authResponse = try? JSONDecoder().decode(AuthResponse.self, from: data)
                if let authResponse = authResponse {
                    UserDefaults.standard.set(authResponse.access_token, forKey: "access_token")
                }
            } else {
                if let error {
                    print("Auth error: \(error)")
                }
                if let response = response as? HTTPURLResponse {
                    var msg = "no data"
                    if let data {
                        msg = String(data: data, encoding: .utf8) ?? "no message"
                    }
                    print("Auth error: \(response.statusCode), message: \(msg)")
                }
            }
        }
        task.resume()
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }

    private func createAuthRequest(code: String) -> URLRequest {
        let url = URL(string: "https://unsplash.com/oauth/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let authRequest = AuthRequest(
                client_id: Constants.accessKey,
                client_secret: Constants.secretKey,
                redirect_uri: Constants.redirectURI,
                code: code,
                grant_type: "authorization_code")
        let body = try? JSONEncoder().encode(authRequest)
        request.httpBody = body
        return request
    }

    private struct AuthRequest: Encodable {
        let client_id: String
        let client_secret: String
        let redirect_uri: String
        let code: String
        let grant_type: String
    }

    private struct AuthResponse: Decodable {
        let access_token: String
        let token_type: String
        let scope: String
        let created_at: Int
    }
}
