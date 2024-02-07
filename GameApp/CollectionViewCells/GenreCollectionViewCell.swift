//
//  GenreCollectionViewCell.swift
//  GameApp
//
//  Created by Luka Podrug on 07.02.2024..
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    let horizontalOffset: CGFloat = 5
    let verticalOffset: CGFloat = 5
    
    let genreNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 10)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupUI() {
        backgroundColor = .clear
        
        contentView.layer.cornerRadius = 10
        
        contentView.addSubview(genreNameLabel)
        genreNameLabel.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
        }
    }
    
    func setupUIFunctionality(selected: Bool) {
        genreNameLabel.textColor = selected ? .white : .black
        contentView.backgroundColor = selected ? .systemBlue : .systemGray2
    }
    
    func setupUIData(genre: GameGenreModel) {
        genreNameLabel.text = genre.name
    }
}
