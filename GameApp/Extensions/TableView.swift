//
//  TableView.swift
//  GameApp
//
//  Created by Luka Podrug on 06.02.2024..
//

import Foundation
import UIKit

extension UITableView {
    func animatedReload() {
        UIView.transition(
            with: self,
            duration: 0.1,
            options: .transitionCrossDissolve,
            animations: { self.reloadData() },
            completion: nil
        )
    }
}
