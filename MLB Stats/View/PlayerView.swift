//
//  PlayerView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-06.
//

import SwiftUI

struct PlayerView: View {
    // MARK: - PROPERTIES
    
    var player: Player
    @State var categoryStats: [String: String] = [:]
    var categories = ["G", "PA", "AB", "R", "H", "HR", "BA", "OBP", "SLG", "OPS", "TB"]
    
    // MARK: - FUNCTIONS
    
    private func hittingStatsTask() {
        Task {
            do {
                let results = try await getCareerHittingStats(gameType: "R", playerID: player.player_id)
                
                if let results = results {
                    categoryStats["G"] = results.g
                    categoryStats["PA"] = results.tpa
                    categoryStats["AB"] = results.ab
                    categoryStats["R"] = results.r
                    categoryStats["H"] = results.h
                    categoryStats["HR"] = results.hr
                    categoryStats["BA"] = results.avg
                    categoryStats["OBP"] = results.obp
                    categoryStats["SLG"] = results.slg
                    categoryStats["OPS"] = results.ops
                    categoryStats["TB"] = results.tb
                }
            } catch {
                print("Error", error)
            }
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Career Hitting")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .padding(.horizontal, 20)
                List {
                    ForEach(0..<categories.count, id: \.self) { item in
                        HStack {
                            Text(categories[item])
                            Spacer()
                            Text(categoryStats[categories[item]] ?? "0")
                        } //: HSTACK
                    } //: FOR
                } //: LIST
                .frame(maxWidth: 640)
                .listStyle(InsetGroupedListStyle())
            } //: VSTACK
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
                hittingStatsTask()
            }
            .navigationBarTitle(player.name_display_first_last)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .background(
                backgroundGradient.ignoresSafeArea()
            )
        } //: NAVIGATION
    }
}

// MARK: - PREVIEW

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(
            player: Player(position: "CF", name_display_first_last: "Mike Trout", team_full: "Los Angeles Angels", player_id: "545361")
        )
    }
}
