//
//  GenresListView.swift
//  GameApp
//
//  Created by Luka Podrug on 02.02.2024..
//

import UIKit
import SnapKit

class GenresListView: UIView {
    let horizontalOffset: CGFloat = 5
    let verticalOffset: CGFloat = 5
    
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
    
    let genresTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .systemGray5
        tableView.layer.cornerRadius = 10
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        return tableView
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
        
        contentView.addSubview(genresTableView)
        genresTableView.snp.makeConstraints { make -> Void in
            make.leading.equalToSuperview().offset(horizontalOffset)
            make.trailing.equalToSuperview().offset(-horizontalOffset)
            make.top.equalToSuperview().offset(verticalOffset)
            make.bottom.equalToSuperview().offset(-verticalOffset)
        }
    }
}
