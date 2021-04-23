//
//  ModeratorViewModel.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/19/21.
//

import Foundation

final class ModeratorViewModel: IdentifiableHashable {
    
    let name: String
    let websiteURL: String
    let id = UUID()

    init(moderator: Moderator) {
        name = moderator.display_name
        websiteURL = moderator.website_url ?? "No website available"
    }
}
