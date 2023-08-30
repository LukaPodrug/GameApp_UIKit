//
//  Extensions.swift
//  GameApp - UIKit
//
//  Created by Luka Podrug on 30.08.2023..
//

import Foundation
import UIKit

extension UIImageView {
    func loadImageFromURL(URL: URL) {
            DispatchQueue.global().async { [weak self] in
                guard let data = try? Data(contentsOf: URL) else { return }
                guard let image = UIImage(data: data) else { return }
                
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
    }
}
