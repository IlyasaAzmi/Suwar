//
//  Photos.swift
//  Suwar
//
//  Created by Ilyasa Azmi on 21/03/20.
//  Copyright © 2020 Ilyasa Azmi. All rights reserved.
//

import Foundation

struct PhotoResults: Decodable {
    var results: [PhotoDetail]
}

struct PhotoDetail: Decodable {
    let id: String
    let width: Int
    let height: Int
    let urls: UrlInfo
}

struct UrlInfo: Decodable {
    let raw: String
    let full: String
    let regular: String
    let small: String
    let thumb: String
}
