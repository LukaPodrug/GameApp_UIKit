//
//  GenreTableViewController.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import UIKit

protocol GenreTableViewDelegate: AnyObject {
    func modalDismiss()
}

class GenreTableViewController: UITableViewController {
    var genreResponse: GenreResponse = GenreResponse(count: 0, next: nil, previous: nil, results: [])
    var selectedGenres: String = UserDefaults().string(forKey: "selectedGenres") ?? ""
    
    weak var genreTableViewDelegate: GenreTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getGenresFromAPI()
        
        title = "Genres"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(submitGenres))
        if UserDefaults().string(forKey: "selectedGenres") == nil {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        tableView.register(UINib(nibName: "GenreTableCellView", bundle: nil), forCellReuseIdentifier: "GenreCell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreResponse.results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreCell", for: indexPath) as! GenreTableViewCell
        
        let genre = genreResponse.results[indexPath.row]
        
        cell.genreLabel.text = genre.name
        if UserDefaults().string(forKey: "selectedGenres") != nil {
            if UserDefaults().string(forKey: "selectedGenres")!.split(separator: ",").contains("\(genre.id)") {
                cell.genreSwitch.isOn = true
            }
            else {
                cell.genreSwitch.isOn = false
            }
        }
        else {
            cell.genreSwitch.isOn = false
        }
        cell.genreSwitch.tag = genre.id
        
        cell.genreSwitch.addTarget(self, action: #selector(genreSwitchToggled), for: .valueChanged)
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
    
    @objc func genreSwitchToggled(mySwitch: UISwitch) {
        if mySwitch.isOn == true {
            if selectedGenres == "" {
                selectedGenres = "\(mySwitch.tag)"
            }
            else {
                selectedGenres = selectedGenres + "," + "\(mySwitch.tag)"
            }
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            var selectedGenresArray = selectedGenres.split(separator: ",")
            selectedGenresArray.removeAll(where: { $0 == "\(mySwitch.tag)" })

            let selectedGenresString = selectedGenresArray.joined(separator: ",")
            
            selectedGenres = selectedGenresString
            if UserDefaults().string(forKey: "selectedGenres") == nil && selectedGenres == "" {
                navigationItem.rightBarButtonItem?.isEnabled = false
            }
        }
    }
    
    @objc func submitGenres() {
        if selectedGenres != "" && selectedGenres != UserDefaults().string(forKey: "selectedGenres") {
            UserDefaults().setValue(selectedGenres, forKey: "selectedGenres")
            print(genreTableViewDelegate)
            genreTableViewDelegate?.modalDismiss()
        }
        dismiss(animated: true)
    }
}
