//
//  Model.swift
//  APITestApp
//
//  Created by Дмитрий Пономаренко on 24.09.23.
//

import Foundation

// MARK: - Page
struct Page: Decodable {
    let page, pageSize, totalPages, totalElements: Int
    let content: [Content]
}

// MARK: - Content
struct Content: Decodable {
    let id: Int
    let name: String
    let image: String?
}
