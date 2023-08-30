//
//  GenreTableViewController.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import UIKit

class GenreTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Genres"
        
        tableView.register(UINib(nibName: "GenreTableCellView", bundle: nil), forCellReuseIdentifier: "GenreCell")
        
        guard let _ = UserDefaults().string(forKey: "selectedGenres") else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(submitGenres))
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as! GenreTableViewCell
        
        return cell
    }
    
    @objc func submitGenres() {
        
    }
}
