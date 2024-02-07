//
//  GenresListViewController.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Combine
import UIKit
import SnapKit
import SDWebImage

class GenresListViewController: UIViewController {
    let genreTableCellHeight: CGFloat = 80
    
    let genresListViewModel: GenresListViewModel
    let genresListView: GenresListView
    
    var subscriptions: Set<AnyCancellable>
    
    init(genresListViewModel: GenresListViewModel, genresListView: GenresListView) {
        self.genresListViewModel = genresListViewModel
        self.genresListView = genresListView
        
        self.subscriptions = Set<AnyCancellable>()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIFunctionality()
    }
    
    func setupUI() {
        navigationItem.title = "Pick genres"
        
        view.backgroundColor = .white
        
        view.addSubview(genresListView)
        genresListView.snp.makeConstraints { make -> Void in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupUIFunctionality() {
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(confirmButtonTapped))
        
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.startAnimating()
        
        genresListView.genresTableView.backgroundView = activityIndicatorView
        
        genresListViewModel.backButtonEnabled
            .assign(to: \.navigationItem.leftBarButtonItem!.isEnabled, on: self)
            .store(in: &subscriptions)
        
        genresListViewModel.confirmButtonEnabled
            .assign(to: \.navigationItem.rightBarButtonItem!.isEnabled, on: self)
            .store(in: &subscriptions)
        
        genresListViewModel.updateGenresTableView
            .sink { updateGenresTableView in
                if updateGenresTableView == true {
                    activityIndicatorView.stopAnimating()
                    self.genresListView.genresTableView.reloadData()
                }
            }
            .store(in: &subscriptions)
        
        genresListView.genresTableView.dataSource = self
        genresListView.genresTableView.delegate = self
        genresListView.genresTableView.register(GenreTableViewCell.self, forCellReuseIdentifier: "GenreTableCell")
    }
}

extension GenresListViewController {
    @objc func backButtonTapped() {
        genresListViewModel.mainCoordinator?.popTopViewController()
    }
    
    @objc func confirmButtonTapped() {
        genresListViewModel.updateSelectedGenresIds()
        genresListViewModel.mainCoordinator?.popTopViewController()
    }
}

extension GenresListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genresListViewModel.genres.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenreTableCell", for: indexPath) as! GenreTableViewCell
        
        cell.genreNameLabel.text = genresListViewModel.genres[indexPath.row].name
        
        cell.genreLikeSwitch.tag = genresListViewModel.genres[indexPath.row].id
        cell.genreLikeSwitch.addTarget(self, action: #selector(genreTableCellSwitchTapped(sender:)), for: .valueChanged)
        
        if genresListViewModel.newSelectedGenresIds.contains(genresListViewModel.genres[indexPath.row].id) {
            cell.genreLikeSwitch.isOn = true
        }
        
        else {
            cell.genreLikeSwitch.isOn = false
        }
        
        guard let imageURL = URL(string: genresListViewModel.genres[indexPath.row].backgroundImage) else {
            cell.genreImageView.image = UIImage(systemName: "photo")
            return cell
        }
        
        cell.genreImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.genreImageView.sd_imageIndicator?.startAnimatingIndicator()
        cell.genreImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "photo"), options: .continueInBackground, completed: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return genreTableCellHeight
    }
}

extension GenresListViewController {
    @objc func genreTableCellSwitchTapped(sender: UISwitch) {
        if sender.isOn {
            genresListViewModel.newSelectedGenresIds.append(sender.tag)
        }
        
        else {
            guard let index: Int = genresListViewModel.newSelectedGenresIds.firstIndex(of: sender.tag) else {
                return
            }
            
            genresListViewModel.newSelectedGenresIds.remove(at: index)
        }
    }
}
