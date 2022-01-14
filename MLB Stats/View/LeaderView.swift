//
//  LeaderView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-14.
//

import SwiftUI

struct LeaderView: View {
    // MARK: - PROPERTIES
    
    @AppStorage("leaderYear", store: .standard) var leaderYear = "2021"
    @AppStorage("leaderStat", store: .standard) var leaderStat = "hr"
    
    @State private var leaderResults: [Leader] = []
    
    // MARK: - FUNCTIONS
    
    private func leaderTask() {
        Task {
            do {
                let results = try await getLeagueLeaders(year: leaderYear, stat: leaderStat)
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
                        .frame(maxWidth: 640)
                        .onSubmit {
                            let filtered = leaderYear.filter {
                                "0123456789".contains($0)
                            }
                            
                            if filtered == leaderYear {
                                leaderTask()
                            }
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
                            
                            Text(leaderResults[rank].hr)
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
