//
//  GameDetailsViewController.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import UIKit

class GameDetailsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var gameImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var gameTitle: UILabel!
    @IBOutlet var releasedLabel: UILabel!
    @IBOutlet var gameReleased: UILabel!
    @IBOutlet var ratingLabel: UILabel!
    @IBOutlet var gameRating: UILabel!
    @IBOutlet var galleryCollection: UICollectionView!
    
    var game: Game
    
    init(game: Game) {
        self.game = game
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameImage.loadImageFromURL(URL: URL(string: game.backgroundImage)!)
        gameImage.contentMode = .scaleAspectFill
        titleLabel.text = "TITLE"
        titleLabel.font = .boldSystemFont(ofSize: 10)
        gameTitle.text = game.name
        gameTitle.font = .systemFont(ofSize: 20)
        releasedLabel.text = "RELEASED"
        releasedLabel.font = .boldSystemFont(ofSize: 10)
        gameReleased.text = game.released
        gameReleased.font = .systemFont(ofSize: 20)
        ratingLabel.text = "RATING"
        ratingLabel.font = .boldSystemFont(ofSize: 10)
        gameRating.text = "\(game.rating)/5"
        gameRating.font = .systemFont(ofSize: 20)
        galleryCollection.dataSource = self
        galleryCollection.register(UINib(nibName: "GameDetailsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "GalleryCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return game.shortScreenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = galleryCollection.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GameDetailsCollectionViewCell
        cell.gameScreenshot.loadImageFromURL(URL: URL(string: game.shortScreenshots[indexPath.row].image)!)
        cell.gameScreenshot.contentMode = .scaleAspectFill
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 3, height: view.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
