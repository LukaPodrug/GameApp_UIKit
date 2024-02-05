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
    
    let gameImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .systemGray3
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let gameNameLabel: UILabel = {
        let label = UILabel()
        
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
        
        contentView.addSubview(gameNameLabel)
        gameNameLabel.snp.makeConstraints { make -> Void in
            make.leading.equalTo(gameImageView.snp.trailing).offset(2 * horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
        }
    }
}
