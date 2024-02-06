//
//  GameTableViewCell.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import SwiftUI
import UIKit
import SnapKit

class GameTableViewCell: UITableViewCell {
    let horizontalOffset: CGFloat = 5
    let verticalOffset: CGFloat = 5
    
    let genresCollectionViewHeight: CGFloat = 30
    
    let gameImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.tintColor = .systemGray2
        imageView.backgroundColor = .systemGray3
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let gameNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    let gameGenresCollectionView: UICollectionView = {
        let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
    
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .systemGray3
        collectionView.layer.cornerRadius = 10
        
        return collectionView
    }()
    
    let gameRatingDonutChartHostingController: UIHostingController = {
        let hostingController = UIHostingController(rootView: DonutChart(statistics: [GameRatingDonutChartModel(title: "Default", value: 1, color: .gray)]))
        
        hostingController.view.backgroundColor = .clear
        
        return hostingController
    }()
    
    let gameRatingLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        
        return label
    }()
    
    func setupUI() {
        backgroundColor = .clear
        
        contentView.backgroundColor = .systemGray4
        contentView.layer.cornerRadius = 10
        contentView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
        }
        
        contentView.addSubview(gameImageView)
        gameImageView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
            make.width.equalTo(gameImageView.snp.height)
        }
        
        contentView.addSubview(gameRatingDonutChartHostingController.view)
        gameRatingDonutChartHostingController.view.snp.makeConstraints { make -> Void in
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
            make.width.equalTo(gameImageView.snp.height)
        }
        
        contentView.addSubview(gameGenresCollectionView)
        gameGenresCollectionView.snp.makeConstraints { make -> Void in
            make.leading.equalTo(gameImageView.snp.trailing).offset(2 * horizontalOffset)
            make.trailing.equalTo(gameRatingDonutChartHostingController.view.snp.leading).offset(-2 * horizontalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
            make.height.equalTo(genresCollectionViewHeight)
        }
        
        contentView.addSubview(gameNameLabel)
        gameNameLabel.snp.makeConstraints { make -> Void in
            make.leading.equalTo(gameImageView.snp.trailing).offset(2 * horizontalOffset)
            make.trailing.equalTo(gameRatingDonutChartHostingController.view.snp.leading).offset(-2 * horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalTo(gameGenresCollectionView.snp.top).offset(-verticalOffset)
        }
        
        contentView.addSubview(gameRatingLabel)
        gameRatingLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(gameRatingDonutChartHostingController.view)
            make.centerY.equalTo(gameRatingDonutChartHostingController.view)
            make.width.equalTo(gameRatingDonutChartHostingController.view)
            make.height.equalTo(gameRatingDonutChartHostingController.view)
        }
    }
}

extension GameTableViewCell {
    func setGenresCollectionViewDataSourceAndDelegate(dataSourceAndDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow row: Int) {
        gameGenresCollectionView.delegate = dataSourceAndDelegate
        gameGenresCollectionView.dataSource = dataSourceAndDelegate
        gameGenresCollectionView.tag = row
        gameGenresCollectionView.reloadData()
    }
}

extension GameTableViewCell {
    func onPressAnimation() {
        UIView.transition(
            with: self,
            duration: 0.0,
            options: .transitionCrossDissolve,
            animations: { self.contentView.alpha = 0.5 },
            completion: { _ in self.onAnimationEnd() }
        )
    }
    
    func onAnimationEnd() {
        UIView.transition(
            with: self,
            duration: 0.4,
            options: .transitionCrossDissolve,
            animations: { self.contentView.alpha = 1 },
            completion: nil
        )
    }
}
