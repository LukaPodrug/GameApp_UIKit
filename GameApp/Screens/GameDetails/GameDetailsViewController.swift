//
//  GameDetailsViewController.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import Combine
import UIKit
import SnapKit
import SDWebImage

class GameDetailsViewController: UIViewController {
    let gameDetailsViewModel: GameDetailsViewModel
    let gameDetailsListView: GameDetailsView
    
    var subscriptions: Set<AnyCancellable>
    
    init(gameDetailsViewModel: GameDetailsViewModel, gameDetailsView: GameDetailsView) {
        self.gameDetailsViewModel = gameDetailsViewModel
        self.gameDetailsListView = gameDetailsView
        
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
        view.backgroundColor = .white
        
        view.addSubview(gameDetailsListView)
        gameDetailsListView.snp.makeConstraints { make -> Void in
            make.leading.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupUIFunctionality() {
        let activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.backgroundColor = .systemGray5
        activityIndicatorView.layer.cornerRadius = 10
        activityIndicatorView.layer.zPosition = 1
        activityIndicatorView.startAnimating()
        
        gameDetailsListView.gameDataView.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        gameDetailsViewModel.gameDetailsData
            .sink { gameDetailsData in
                if let gameDetails = gameDetailsData {
                    activityIndicatorView.removeFromSuperview()
                    self.setupUIData(gameDetails: gameDetails)
                }
            }
            .store(in: &subscriptions)
        
        gameDetailsListView.gameImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        gameDetailsListView.gameImageView.sd_imageIndicator?.startAnimatingIndicator()
    }
    
    func setupUIData(gameDetails: GameDetailsModel) {
        gameDetailsListView.gameNameValueLabel.text = gameDetails.name
        gameDetailsListView.gameDescriptionValueTextView.text = gameDetails.descriptionRaw
        
        gameDetailsListView.gameRatingDonutChartHostingController.rootView = DonutChart(statistics: [GameRatingDonutChartModel(title: "Rating", value: gameDetails.rating, color: .blue), GameRatingDonutChartModel(title: "Gap", value: 5 - gameDetails.rating, color: .clear)])
        gameDetailsListView.gameMetacriticDonutChartHostingController.rootView = DonutChart(statistics: [GameRatingDonutChartModel(title: "Metacritic", value: gameDetails.metacritic, color: .blue), GameRatingDonutChartModel(title: "Gap", value: 100 - gameDetails.metacritic, color: .clear)])
        
        gameDetailsListView.gameRatingValueLabel.text = String(format: "%.1f", gameDetails.rating / 5 * 100) + "%"
        gameDetailsListView.gameMetacriticValueLabel.text = String(format: "%.1f", gameDetails.metacritic / 100 * 100) + "%"
        
        guard let imageURL = URL(string: gameDetails.backgroundImage) else {
            gameDetailsListView.gameImageView.image = UIImage(systemName: "photo")
            return
        }
        
        gameDetailsListView.gameImageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .continueInBackground, completed: nil)
    }
}
