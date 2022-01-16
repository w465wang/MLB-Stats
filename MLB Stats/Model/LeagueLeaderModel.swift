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
    var pos: String
    var tb: String
    var avg: String
    var slg: String
    var ops: String
    var player_id: String
    var hr: String
    var name_display_roster: String
    var g: String
    var team_name: String
    var tpa: String
    var h: String
    var obp: String
    var r: String
    var ab: String
}
