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
        gameTitle.text = game.name
        releasedLabel.text = "RELEASED"
        gameReleased.text = game.released
        ratingLabel.text = "RATING"
        gameRating.text = "\(game.rating)"
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
        cell.backgroundColor = .blue
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 3)

        return CGSize(width: scaleFactor, height: scaleFactor)
    }
}
