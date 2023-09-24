//
//  ImageView.swift
//  APITestApp
//
//  Created by Дмитрий Пономаренко on 24.09.23.
//

import UIKit

extension UIImageView {
    func load(url: String) {
        guard let url = URL(string: url) else {
            return
            
        }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
