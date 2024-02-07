//
//  GenreTableViewCell.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import UIKit
import SnapKit
import SDWebImage

class GenreTableViewCell: UITableViewCell {
    let horizontalOffset: CGFloat = 5
    let verticalOffset: CGFloat = 5
    
    let genreImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.tintColor = .systemGray2
        imageView.backgroundColor = .systemGray3
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let genreNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    let genreLikeSwitch: UISwitch = {
        let breaker = UISwitch()
        
        return breaker
    }()
    
    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupUIFunctionality()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
        
        contentView.addSubview(genreImageView)
        genreImageView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
            make.width.equalTo(genreImageView.snp.height)
        }
        
        contentView.addSubview(genreLikeSwitch)
        genreLikeSwitch.snp.makeConstraints { make -> Void in
            make.trailing.equalToSuperview().offset(-2 * horizontalOffset)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(genreNameLabel)
        genreNameLabel.snp.makeConstraints { make -> Void in
            make.leading.equalTo(genreImageView.snp.trailing).offset(2 * horizontalOffset)
            make.trailing.equalTo(genreLikeSwitch.snp.leading).offset(-2 * horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
        }
    }
    
    func setupUIFunctionality() {
        selectionStyle = .none
    }
    
    func setupUIData(genre: GenreModel, selectedGenresIds: [Int]) {
        genreNameLabel.text = genre.name
        
        genreLikeSwitch.tag = genre.id
        genreLikeSwitch.isOn = selectedGenresIds.contains(genre.id)
        
        guard let imageURL = URL(string: genre.backgroundImage) else {
            genreImageView.image = UIImage(systemName: "photo")
            return
        }
        
        genreImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        genreImageView.sd_imageIndicator?.startAnimatingIndicator()
        genreImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(systemName: "photo"), options: .continueInBackground, completed: nil)
    }
}
