//
//  NewsData.swift
//  WeatherApp
//
//  Created by Felipe Lobo on 01/04/21.
//

import Foundation

struct NewsData: Codable {
    let articles: [Articles]
}

struct Articles: Codable {
    let title: String
    let url: String
    let publishedAt: String
    let urlToImage: String?
}
