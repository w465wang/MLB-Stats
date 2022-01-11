//
//  PlayerStatsBox.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-10.
//

import SwiftUI

struct PlayerStatsBox: View {
    // MARK: - PROPERTIES
    
    @State var isExpandedCareer: Bool = false
    @State var hittingStats: [HittingStats] = [HittingStats()]
    @State var categoryStats: [String: String] = [:]
    var categories = ["G", "PA", "AB", "R", "H", "HR", "BA", "OBP", "SLG", "OPS", "TB"]
    
    var playerID: String
    var title: String
    var gameType: String
    
    // MARK: - FUNCTIONS
    
    private func updateCategoryStats() {
        categoryStats["G"] = hittingStats[0].g
        categoryStats["PA"] = hittingStats[0].tpa
        categoryStats["AB"] = hittingStats[0].ab
        categoryStats["R"] = hittingStats[0].r
        categoryStats["H"] = hittingStats[0].h
        categoryStats["HR"] = hittingStats[0].hr
        categoryStats["BA"] = hittingStats[0].avg
        categoryStats["OBP"] = hittingStats[0].obp
        categoryStats["SLG"] = hittingStats[0].slg
        categoryStats["OPS"] = hittingStats[0].ops
        categoryStats["TB"] = hittingStats[0].tb
    }
    
    // MARK: - BODY
    
    var body: some View {
        GroupBox() {
            DisclosureGroup(isExpanded: $isExpandedCareer) {
                ForEach(0..<categories.count, id: \.self) { ind in
                    Divider().padding(.vertical, 2)
                    
                    HStack {
                        Text(categories[ind])
                        
                        Spacer()
                        
                        Text(categoryStats[categories[ind]] ?? "0")
                    } //: HSTACK
                } //: FOR
            } label: {
                Text(title)
                    .foregroundColor(.primary)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
            } //: DISCLOSURE GROUP
            .onChange(of: isExpandedCareer) { _ in
                updateCategoryStats()
            }
        } //: BOX
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .task {
            do {
                if let stats = try await getCareerHittingStats(gameType: gameType, playerID: playerID) {
                    hittingStats = [stats]
                }
            } catch {
                print("Error", error)
            }
        }
    }
}

struct PlayerStatsBox_Previews: PreviewProvider {
    static var previews: some View {
        PlayerStatsBox(playerID: "121578", title: "Career Regular Season", gameType: "R")
    }
}
