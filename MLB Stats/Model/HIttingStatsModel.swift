//
//  HIttingStatsModel.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-07.
//

import SwiftUI

struct CareerHittingResult: Codable {
    var sport_career_hitting: CareerHitting
}

struct CareerHitting: Codable {
    var queryResults: CareerHittingQueryResult
}

struct CareerHittingQueryResult: Codable {
    var row: HittingStats?
}

struct HittingStats: Codable, Hashable {
    var hr: String
    var tb: String
    var avg: String
    var slg: String
    var ops: String
    var g: String
    var tpa: String
    var h: String
    var obp: String
    var r: String
    var ab: String
}
