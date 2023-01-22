//
//  ViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 20.01.2023.
//

import UIKit

class ImagesListViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

