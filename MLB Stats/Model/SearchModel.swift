//
//  SearchModel.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

struct SearchResult: Codable {
    var search_player_all: SearchPlayerAll
}

struct SearchPlayerAll: Codable {
    var queryResults: QueryResult
}

struct QueryResult: Codable {
    var totalSize: String
    var row: [Player]?
}

struct Player: Codable {
    var position: String
    var birth_country: String
    var name_display_first_last: String
    var team_full: String
}
