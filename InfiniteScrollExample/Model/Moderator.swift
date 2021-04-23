//
//  Moderator.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/12/21.
//

import Foundation

struct Container: Decodable {
    let items: [Moderator]
    var has_more: Bool
    var quota_max: Int
    var quota_remaining: Int
    var page: Int
}

struct Moderator: Decodable {
    
    let account_id: Int
    let is_employee: Bool
    let website_url: String?
    let profile_image: String
    let display_name: String
    let location: String?
}
