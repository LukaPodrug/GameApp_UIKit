//
//  GameDetailsView.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import SwiftUI
import UIKit

class GameDetailsView: UIView {
    let horizontalOffset: CGFloat = 5
    let verticalOffset: CGFloat = 5
    
    let labelHeight: CGFloat = 15
    let labelValueHeight: CGFloat = 20
    let textViewHeight: CGFloat = 200
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let gameImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.tintColor = .systemGray4
        
        return imageView
    }()
    
    let gameDataView: UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = 10
        view.backgroundColor = .systemGray5
        
        return view
    }()
    
    let gameNameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Name"
        label.font = .systemFont(ofSize: 10)
        
        return label
    }()
    
    let gameNameValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        
        return label
    }()
    
    let gameDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Description"
        label.font = .systemFont(ofSize: 10)
        
        return label
    }()
    
    let gameDescriptionValueTextView: UITextView = {
        let textView = UITextView()
        
        textView.font = .systemFont(ofSize: 15)
        textView.layer.cornerRadius = 10
        textView.backgroundColor = .systemGray4
        textView.isEditable = false
        
        return textView
    }()
    
    let gameChartsView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .systemGray4
        view.layer.cornerRadius = 10
        
        return view
    }()
    
    let gameRatingLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Rating"
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        
        return label
    }()
    
    let gameRatingDonutChartHostingController: UIHostingController = {
        let hostingController = UIHostingController(rootView: DonutChart(statistics: [GameRatingDonutChartModel(title: "Default", value: 1, color: .gray)]))
        
        hostingController.view.backgroundColor = .clear
        
        return hostingController
    }()
    
    let gameRatingValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        
        return label
    }()
    
    let gameMetacriticLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Metacritic"
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        
        return label
    }()
    
    let gameMetacriticDonutChartHostingController: UIHostingController = {
        let hostingController = UIHostingController(rootView: DonutChart(statistics: [GameRatingDonutChartModel(title: "Default", value: 1, color: .gray)]))
        
        hostingController.view.backgroundColor = .clear
        
        return hostingController
    }()
    
    let gameMetacriticValueLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.textAlignment = .center
        
        return label
    }()
    
    init() {
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
            make.width.equalToSuperview().offset(-2 * horizontalOffset)
            make.height.greaterThanOrEqualToSuperview().offset(-2 * verticalOffset)
        }
        
        contentView.addSubview(gameImageView)
        gameImageView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.height.equalTo(gameImageView.snp.width).dividedBy(1.5)
        }
        
        contentView.addSubview(gameDataView)
        gameDataView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalTo(gameImageView.snp.bottom).offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
        }
        
        gameDataView.addSubview(gameNameLabel)
        gameNameLabel.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.height.equalTo(labelHeight)
        }
        
        gameDataView.addSubview(gameNameValueLabel)
        gameNameValueLabel.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalTo(gameNameLabel.snp.bottom).offset(verticalOffset)
            make.height.equalTo(labelValueHeight)
        }
        
        gameDataView.addSubview(gameDescriptionLabel)
        gameDescriptionLabel.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalTo(gameNameValueLabel.snp.bottom).offset(verticalOffset)
            make.height.equalTo(labelHeight)
        }
        
        gameDataView.addSubview(gameDescriptionValueTextView)
        gameDescriptionValueTextView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalTo(gameDescriptionLabel.snp.bottom).offset(verticalOffset)
            make.height.equalTo(textViewHeight)
        }
        
        gameDataView.addSubview(gameChartsView)
        gameChartsView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalTo(gameDescriptionValueTextView.snp.bottom).offset(3 * verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
        }
        
        gameChartsView.addSubview(gameRatingLabel)
        gameRatingLabel.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalTo(gameDataView.snp.centerX)
            make.top.equalToSuperview().offset(verticalOffset)
            make.height.equalTo(labelHeight)
        }
        
        gameChartsView.addSubview(gameMetacriticLabel)
        gameMetacriticLabel.snp.makeConstraints { make -> Void in
            make.leading.equalTo(gameDataView.snp.centerX)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.height.equalTo(labelHeight)
        }
        
        gameChartsView.addSubview(gameRatingDonutChartHostingController.view)
        gameRatingDonutChartHostingController.view.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(5 * horizontalOffset)
            make.trailing.equalTo(gameDataView.snp.centerX).offset(-5 * horizontalOffset)
            make.top.equalTo(gameRatingLabel.snp.bottom).offset(5 * verticalOffset)
            make.bottom.equalToSuperview().offset(-5 * verticalOffset)
        }
        
        gameChartsView.addSubview(gameMetacriticDonutChartHostingController.view)
        gameMetacriticDonutChartHostingController.view.snp.makeConstraints { make -> Void in
            make.leading.equalTo(gameDataView.snp.centerX).offset(5 * horizontalOffset)
            make.trailing.equalToSuperview().offset(-5 * horizontalOffset)
            make.top.equalTo(gameMetacriticLabel.snp.bottom).offset(5 * verticalOffset)
            make.bottom.equalToSuperview().offset(-5 * verticalOffset)
        }
        
        gameChartsView.addSubview(gameRatingValueLabel)
        gameRatingValueLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(gameRatingDonutChartHostingController.view)
            make.centerY.equalTo(gameRatingDonutChartHostingController.view)
            make.width.equalTo(gameRatingDonutChartHostingController.view)
            make.height.equalTo(gameRatingDonutChartHostingController.view)
        }
        
        gameChartsView.addSubview(gameMetacriticValueLabel)
        gameMetacriticValueLabel.snp.makeConstraints { make -> Void in
            make.centerX.equalTo(gameMetacriticDonutChartHostingController.view)
            make.centerY.equalTo(gameMetacriticDonutChartHostingController.view)
            make.width.equalTo(gameMetacriticDonutChartHostingController.view)
            make.height.equalTo(gameMetacriticDonutChartHostingController.view)
        }
    }
}
