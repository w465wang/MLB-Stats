//
//  Network.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-05.
//

import SwiftUI

func getSearchResults(active: String, query: String) async throws -> [Player] {
    let newActive = active == "A" ? "" : "&active_sw='\(active)'"
    
    var newQuery = query + "%25"
    if newQuery.contains(" ") {
        newQuery = newQuery.replacingOccurrences(of: " ", with: "%20")
    }

    guard let url = URL(string: "https://lookup-service-prod.mlb.com/json/named.search_player_all.bam?sport_code='mlb'\(newActive)&name_part='\(newQuery)'") else {
        print("Missing URL")
        return []
    }
    
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        print("Error while fetching data")
        return []
    }
    
    let decodedSearchCheck = try JSONDecoder().decode(SearchResultCheck.self, from: data)
    
    if decodedSearchCheck.search_player_all.queryResults.totalSize == "1" {
        let decodedSearchSingle = try JSONDecoder().decode(SearchResultSingle.self, from: data)
        return [decodedSearchSingle.search_player_all.queryResults.row]
    } else {
        let decodedSearch = try JSONDecoder().decode(SearchResult.self, from: data)
        
        if let row = decodedSearch.search_player_all.queryResults.row {
            return row
        } else {
            return []
        }
    }
}

func getCareerHittingStats(gameType: String, playerID: String) async throws -> HittingStats? {
    guard let url = URL(string: "https://lookup-service-prod.mlb.com/json/named.sport_career_hitting.bam?league_list_id='mlb'&game_type='\(gameType)'&player_id='\(playerID)'") else {
        print("Missing URL")
        return nil
    }
    
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        print("Error while fetching data")
        return nil
    }
    
    let decodedHittingStats = try JSONDecoder().decode(CareerHittingResult.self, from: data)
    
    return decodedHittingStats.sport_career_hitting.queryResults.row
}

func getLeagueLeaders(year: String, stat: String) async throws -> [Leader] {
    guard let url = URL(string: "https://lookup-service-prod.mlb.com/json/named.leader_hitting_repeater.bam?sport_code='mlb'&results=5&game_type='R'&season='\(year)'&sort_column='\(stat)'") else {
        print("Missing URL")
        return []
    }
    
    let urlRequest = URLRequest(url: url)
    let (data, response) = try await URLSession.shared.data(for: urlRequest)
    
    guard (response as? HTTPURLResponse)?.statusCode == 200 else {
        print("Error while fetching data")
        return []
    }
    
    let decodedHittingStats = try JSONDecoder().decode(LeagueLeaders.self, from: data)
    
    return decodedHittingStats.leader_hitting_repeater.leader_hitting_mux.queryResults.row
}

