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

class HittingStats: Codable, ObservableObject {
    init() {
        hr = "0"
        tb = "0"
        avg = ".000"
        slg = ".000"
        ops = ".000"
        g = "0"
        tpa = "0"
        h = "0"
        obp = ".000"
        r = "0"
        ab = "0"
    }
    
    enum CodingKeys: String, CodingKey {
        case hr
        case tb
        case avg
        case slg
        case ops
        case g
        case tpa
        case h
        case obp
        case r
        case ab
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hr = try values.decode(String.self, forKey: .hr)
        tb = try values.decode(String.self, forKey: .tb)
        avg = try values.decode(String.self, forKey: .avg)
        slg = try values.decode(String.self, forKey: .slg)
        ops = try values.decode(String.self, forKey: .ops)
        g = try values.decode(String.self, forKey: .g)
        tpa = try values.decode(String.self, forKey: .tpa)
        h = try values.decode(String.self, forKey: .h)
        obp = try values.decode(String.self, forKey: .obp)
        r = try values.decode(String.self, forKey: .r)
        ab = try values.decode(String.self, forKey: .ab)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hr, forKey: .hr)
        try container.encode(tb, forKey: .tb)
        try container.encode(avg, forKey: .avg)
        try container.encode(slg, forKey: .slg)
        try container.encode(ops, forKey: .ops)
        try container.encode(g, forKey: .g)
        try container.encode(tpa, forKey: .tpa)
        try container.encode(h, forKey: .h)
        try container.encode(obp, forKey: .obp)
        try container.encode(r, forKey: .r)
        try container.encode(ab, forKey: .ab)
    }
    
    @Published var hr: String
    @Published var tb: String
    @Published var avg: String
    @Published var slg: String
    @Published var ops: String
    @Published var g: String
    @Published var tpa: String
    @Published var h: String
    @Published var obp: String
    @Published var r: String
    @Published var ab: String
}
