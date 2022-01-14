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
    
    @State private var leaderResults: [Leader] = [Leader(name_display_first_last: "", hr: "0", team_name: ""), Leader(name_display_first_last: "", hr: "0", team_name: ""), Leader(name_display_first_last: "", hr: "0", team_name: ""), Leader(name_display_first_last: "", hr: "0", team_name: ""), Leader(name_display_first_last: "", hr: "0", team_name: "")]
    
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
                    ForEach(0..<leaderResults.count, id: \.self) { ind in
                        HStack {
                            Text("\(ind + 1).")
                                .font(.system(.headline))
                            
                            VStack(alignment: .leading) {
                                Text(leaderResults[ind].name_display_first_last)
                                    .font(.system(.headline))
                                Text(leaderResults[ind].team_name)
                                    .font(.system(.footnote))
                            } //: VSTACK
                            
                            Spacer()
                            
                            Text(leaderResults[ind].hr)
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
