//
//  LeagueLeaderModel.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-14.
//

import SwiftUI

struct LeagueLeaders: Codable {
    var leader_hitting_repeater: LeaderHittingRepeater
}

struct LeaderHittingRepeater: Codable {
    var leader_hitting_mux: LeaderHittingMux
}

struct LeaderHittingMux: Codable {
    var queryResults: LeagueLeaderQueryResult
}

struct LeagueLeaderQueryResult: Codable {
    var row: [Leader]
}

struct Leader: Codable, Hashable {
    var name_display_first_last: String
    var hr: String
    var team_name: String
}
