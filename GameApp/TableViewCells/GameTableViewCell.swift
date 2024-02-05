//
//  GameTableViewCell.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

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
        
        return label
    }()
    
    let gameGenresCollectionView: UICollectionView = {
        let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.scrollDirection = .horizontal
        collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: collectionViewFlowLayout)
    
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
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
        
        contentView.addSubview(gameGenresCollectionView)
        gameGenresCollectionView.snp.makeConstraints { make -> Void in
            make.leading.equalTo(gameImageView.snp.trailing).offset(2 * horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
            make.height.equalTo(genresCollectionViewHeight)
        }
        
        contentView.addSubview(gameNameLabel)
        gameNameLabel.snp.makeConstraints { make -> Void in
            make.leading.equalTo(gameImageView.snp.trailing).offset(2 * horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalTo(gameGenresCollectionView.snp.top).offset(-verticalOffset)
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
