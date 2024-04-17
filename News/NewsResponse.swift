//
//  NewsResponse.swift
//  News
//
//  Created by saeed shaikh on 4/17/24.
//

import Foundation
//dtos
struct NewsResponse: Codable{
    let articles: [Article]
}
struct Article: Codable{
    let source : Source
    let author: String?
    let content: String?
    let description: String?
    let title : String
    let url : String
    let urlToImage : String?
    let publishedAt : String
}
struct Source: Codable{
    let id : String?
    let name : String
}
