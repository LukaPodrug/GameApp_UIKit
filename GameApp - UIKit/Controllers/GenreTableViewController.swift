//
//  GenreTableViewController.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import UIKit

class GenreTableViewController: UITableViewController {
    var genreResponse: GenreResponse = GenreResponse(count: 0, next: nil, previous: nil, results: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGenresFromAPI()
        
        title = "Genres"
        
        tableView.register(UINib(nibName: "GenreTableCellView", bundle: nil), forCellReuseIdentifier: "GenreCell")
        
        guard let _ = UserDefaults().string(forKey: "selectedGenres") else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(submitGenres))
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreResponse.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as! GenreTableViewCell
        
        let genre = genreResponse.results[indexPath.row]
        
        cell.genreLabel.text = genre.name
        cell.genreSwitch.isOn = false
        
        return cell
    }
    
    func getGenresFromAPI() {
        APIManager.shared.getGenres { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let genreResponse):
                    self.genreResponse = genreResponse
                    self.tableView.reloadData()
                case .failure:
                    print("Error with getting genres from API")
                }
            }
        }
    }
    
    @objc func submitGenres() {
        
    }
}
