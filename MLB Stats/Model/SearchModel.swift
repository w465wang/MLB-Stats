//
//  SearchModel.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

// MARK: - Regular search result

struct SearchResult: Codable {
    var search_player_all: SearchPlayerAll
}

struct SearchPlayerAll: Codable {
    var queryResults: QueryResult
}

struct QueryResult: Codable {
    var row: [Player]?
}

struct Player: Codable, Hashable {
    var position: String
    var name_display_first_last: String
    var team_full: String
    var player_id: String
}

// MARK: - Single search result

struct SearchResultSingle: Codable {
    var search_player_all: SearchPlayerSingle
}

struct SearchPlayerSingle: Codable {
    var queryResults: QueryResultSingle
}

struct QueryResultSingle: Codable {
    var row: Player
}

// MARK: - Check search result

struct SearchResultCheck: Codable {
    var search_player_all: SearchPlayerCheck
}

struct SearchPlayerCheck: Codable {
    var queryResults: QuerySize
}

struct QuerySize: Codable {
    var totalSize: String
}
