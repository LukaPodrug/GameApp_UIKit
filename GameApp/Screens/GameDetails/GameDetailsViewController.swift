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
    var subscriptions: Set<AnyCancellable>
    let gameDetailsViewModel: GameDetailsViewModel
    let gameDetailsListView: GameDetailsView
    
    init() {
        self.subscriptions = Set<AnyCancellable>()
        self.gameDetailsViewModel = GameDetailsViewModel()
        self.gameDetailsListView = GameDetailsView()
        
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
        UserDefaults.standard
            .publisher(for: \.selectedGameId)
            .sink(receiveValue: { selectedGameId in
                self.gameDetailsViewModel.getGameDetails()
            })
            .store(in: &subscriptions)
        
        gameDetailsViewModel.updateGameDetailsData
            .sink { updateGameDetailsData in
                if updateGameDetailsData == true {
                    self.setupUIData()
                }
            }
            .store(in: &subscriptions)
        
        gameDetailsListView.gameImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        gameDetailsListView.gameImageView.sd_imageIndicator?.startAnimatingIndicator()
    }
    
    func setupUIData() {
        gameDetailsListView.gameNameValueLabel.text = gameDetailsViewModel.gameDetails!.name
        gameDetailsListView.gameDescriptionValueTextView.text = gameDetailsViewModel.gameDetails!.description_raw
        
        gameDetailsListView.gameRatingDonutChartHostingController.rootView = DonutChart(statistics: [GameRatingDonutChartModel(title: "Rating", value: gameDetailsViewModel.gameDetails!.rating, color: .blue), GameRatingDonutChartModel(title: "Gap", value: 5 - gameDetailsViewModel.gameDetails!.rating, color: .clear)])
        gameDetailsListView.gameMetacriticDonutChartHostingController.rootView = DonutChart(statistics: [GameRatingDonutChartModel(title: "Rating", value: gameDetailsViewModel.gameDetails!.metacritic, color: .blue), GameRatingDonutChartModel(title: "Gap", value: 100 - gameDetailsViewModel.gameDetails!.metacritic, color: .clear)])
        
        gameDetailsListView.gameRatingValueLabel.text = String(format: "%.1f", gameDetailsViewModel.gameDetails!.rating / 5 * 100) + "%"
        gameDetailsListView.gameMetacriticValueLabel.text = String(format: "%.1f", gameDetailsViewModel.gameDetails!.metacritic / 100 * 100) + "%"
        
        guard let imageURL = URL(string: gameDetailsViewModel.gameDetails!.background_image) else {
            gameDetailsListView.gameImageView.image = UIImage(systemName: "photo")
            return
        }
        
        gameDetailsListView.gameImageView.sd_setImage(with: imageURL, placeholderImage: nil, options: .continueInBackground, completed: nil)
    }
}
