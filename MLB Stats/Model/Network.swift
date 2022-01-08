//
//  Network.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

func getSearchResults(active: String, query: String) async throws -> [Player] {
    let newActive = active == "A" ? "" : "&active_sw='\(active)'"
    
    var newQuery = query
    if query.contains(" ") {
        newQuery = query.replacingOccurrences(of: " ", with: "%20")
    } else {
        newQuery.append("%25")
    }

    // TODO: Add active_sw parameter
    guard let url = URL(string: "https://lookup-service-prod.mlb.com/json/named.search_player_all.bam?sport_code='mlb'\(newActive)&name_part='\(newQuery)'") else {
        fatalError("Missing URL")
    }
    
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        fatalError("Error while fetching data")
    }
    
    let decodedSearch = try JSONDecoder().decode(SearchResult.self, from: data)
    
    if let row = decodedSearch.search_player_all.queryResults.row {
        return row
    } else {
        return []
    }
}

func getCareerHittingStats(gameType: String, playerID: String) async throws -> HittingStats? {
    guard let url = URL(string: "https://lookup-service-prod.mlb.com/json/named.sport_career_hitting.bam?league_list_id=%27mlb%27&game_type='\(gameType)'&player_id='\(playerID)'") else {
        fatalError("Missing URL")
    }
    
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        fatalError("Error while fetching data")
    }
    
    let decodedHittingStats = try JSONDecoder().decode(CareerHittingResult.self, from: data)
    
    return decodedHittingStats.sport_career_hitting.queryResults.row
}
