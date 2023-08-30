//
//  GameTableViewController.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import UIKit

class GameTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Games"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .done, target: self, action: #selector(showGenreSelectionModal))
        
        guard let selectedGenres = UserDefaults().string(forKey: "selectedGenres") else {
            showGenreSelectionModal()
            return
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    @objc func showGenreSelectionModal() {
        let gameTableViewController = GameTableViewController()
        
        navigationController?.modalPresentationStyle = .pageSheet
        navigationController?.present(gameTableViewController, animated: true)
    }
}
