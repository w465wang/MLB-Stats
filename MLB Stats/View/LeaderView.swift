//
//  LeaderView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-14.
//

import SwiftUI

struct LeaderView: View {
    // MARK: - PROPERTIES
    
    @AppStorage("leaderYear", store: .standard) private var leaderYear = "2021"
    @AppStorage("leaderStat", store: .standard) private var leaderStat = "HR"
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var leaderResults: [Leader] = []
    @State private var leaderResultsDict: [String: [String]] = ["":[]]
    private var stats = ["G", "PA", "AB", "R", "H", "HR", "BA", "OBP", "SLG", "OPS", "TB"]
    private var statsDict = ["G":"g", "PA":"tpa", "AB":"ab", "R":"r", "H":"h", "HR":"hr", "BA":"avg", "OBP":"obp", "SLG":"slg", "OPS":"ops", "TB":"tb"]
    
    // MARK: - FUNCTIONS
    
    private func leaderTask() {
        Task {
            do {
                let results = try await getLeagueLeaders(year: leaderYear, stat: statsDict[leaderStat]!)
                
                var tempDict: [String: [String]] = ["":[]]
                
                for stat in stats {
                    tempDict[stat] = []
                }
                
                for rank in 0..<results.count {
                    tempDict["HR"]!.append(results[rank].hr)
                    tempDict["TB"]!.append(results[rank].tb)
                    tempDict["BA"]!.append(results[rank].avg)
                    tempDict["SLG"]!.append(results[rank].slg)
                    tempDict["OPS"]!.append(results[rank].ops)
                    tempDict["G"]!.append(results[rank].g)
                    tempDict["PA"]!.append(results[rank].tpa)
                    tempDict["H"]!.append(results[rank].h)
                    tempDict["OBP"]!.append(results[rank].obp)
                    tempDict["R"]!.append(results[rank].r)
                    tempDict["AB"]!.append(results[rank].ab)
                }
                
                leaderResultsDict = tempDict
                leaderResults = results
            } catch {
                print("Error", error)
            }
        }
    }
    
    private func getRank(rank: Int) -> String {
        if rank > 0 {
            if leaderResults[rank].hr == leaderResults[rank - 1].hr {
                return getRank(rank: rank - 1)
            }
        }
        
        return "\(rank + 1)."
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("League Leaders")
                        .font(.system(.largeTitle, design: .default))
                        .fontWeight(.heavy)
                        .padding(.leading, 4)
                } //: HSTACK
                .padding(.horizontal, 15)
                
                HStack {
                    TextField(leaderYear, text: $leaderYear)
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                        .background(
                            Color(.secondarySystemBackground)
                        )
                        .cornerRadius(10)
                        .clipped()
                        .onSubmit {
                            let filtered = leaderYear.filter {
                                "0123456789".contains($0)
                            }
                            
                            if filtered == leaderYear {
                                leaderTask()
                            }
                        }
                    
                    Picker(leaderStat, selection: $leaderStat) {
                        ForEach(stats, id: \.self) {
                            Text($0)
                        }
                    }
                    .accentColor(colorScheme == .dark ? .white : .black)
                    .padding()
                    .background(
                        Color(.secondarySystemBackground)
                    )
                    .cornerRadius(10)
                    .clipped()
                    .onChange(of: leaderStat) { _ in
                        leaderTask()
                    }
                } //: HSTACK
                .padding(.horizontal, 15)
                
                List {
                    ForEach(0..<leaderResults.count, id: \.self) { rank in
                        HStack {
                            Text(getRank(rank: rank))
                                .font(.system(.headline))
                            
                            ZStack(alignment: .leading) {
                                VStack(alignment: .leading) {
                                    Text(leaderResults[rank].name_display_first_last)
                                        .font(.system(.headline))
                                    Text(leaderResults[rank].team_name)
                                        .font(.system(.footnote))
                                } //: VSTACK
                                
                                NavigationLink(destination: PlayerView(player: Player(position: leaderResults[rank].pos, name_display_first_last: leaderResults[rank].name_display_first_last, name_display_roster: leaderResults[rank].name_display_roster, team_full: leaderResults[rank].team_name, player_id: leaderResults[rank].player_id))) {
                                    EmptyView()
                                }
                            } //: ZSTACK
                            
                            Spacer()
                            
                            Text(leaderResultsDict[leaderStat]![rank])
                                .font(.system(.headline))
                        } //: HSTACK
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                    } //: FOR
                } //: LIST
            } //: VSTACK
            .onAppear() {
                UITableView.appearance().backgroundColor = .clear
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(.vertical, 10)
            .background(
                backgroundGradient.ignoresSafeArea()
            )
            .navigationBarHidden(true)
            .task {
                leaderTask()
            }
        } //: NAVIGATION
    }
}

struct LeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderView()
    }
}
