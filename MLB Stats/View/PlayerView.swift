//
//  PlayerView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-06.
//

import SwiftUI

struct PlayerView: View {
    // MARK: - PROPERTIES
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var player: Player
    @State var isInFavourites: Bool = false
    @State var isExpandedCareer: Bool = false
    @State var hittingStats: [HittingStats] = [HittingStats()]
    @State var categoryStats: [String: String] = [:]
    var categories = ["G", "PA", "AB", "R", "H", "HR", "BA", "OBP", "SLG", "OPS", "TB"]
    
    // MARK: - FUNCTIONS
    
    private func updateCategoryStats() {
        categoryStats["G"] = self.hittingStats[0].g
        categoryStats["PA"] = self.hittingStats[0].tpa
        categoryStats["AB"] = self.hittingStats[0].ab
        categoryStats["R"] = self.hittingStats[0].r
        categoryStats["H"] = self.hittingStats[0].h
        categoryStats["HR"] = self.hittingStats[0].hr
        categoryStats["BA"] = self.hittingStats[0].avg
        categoryStats["OBP"] = self.hittingStats[0].obp
        categoryStats["SLG"] = self.hittingStats[0].slg
        categoryStats["OPS"] = self.hittingStats[0].ops
        categoryStats["TB"] = self.hittingStats[0].tb
    }
    
    private func checkFavourites() {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "playerID == %@", player.player_id
        )
        
        do {
            let object = try viewContext.fetch(fetchRequest)
            
            isInFavourites = object.count > 0
        } catch {
            let nsError = error as NSError
            print("Error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func addItem(player: Player) {
        let newItem = Item(context: viewContext)
        newItem.name = player.name_display_first_last
        newItem.lastName = player.name_display_roster
        newItem.playerID = player.player_id
        newItem.position = player.position
        newItem.team = player.team_full

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func deleteItem(id: String) {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "playerID == %@", id
        )
        
        do {
            let object = try viewContext.fetch(fetchRequest)
            viewContext.delete(object.first!)
            
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            print("Error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - BODY
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                HStack() {
                    Text(player.name_display_first_last)
                        .font(.system(.largeTitle, design: .default))
                        .fontWeight(.heavy)
                        .padding(.leading, 4)
                    
                    Spacer()
                    
                    Button(action: {
                        if isInFavourites {
                            deleteItem(id: player.player_id)
                        } else {
                            addItem(player: player)
                        }
                        
                        isInFavourites.toggle()
                    }, label: {
                        Image(systemName: isInFavourites ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.system(size: 24))
                    })
                        .onAppear {
                            checkFavourites()
                        }
                } //: HSTACK
                .padding(.horizontal, 15)
                
                
                ScrollView() {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Hitting Statistics")
                            .font(.title)
                            .fontWeight(.heavy)
                            .padding(.horizontal, 20)
                        
                        PlayerStatsBox(playerID: player.player_id, title: "Career Regular Season", gameType: "R")
                        PlayerStatsBox(playerID: player.player_id, title: "Career Wild Card", gameType: "F")
                        PlayerStatsBox(playerID: player.player_id, title: "Career Division Series", gameType: "D")
                        PlayerStatsBox(playerID: player.player_id, title: "Career Championship Series", gameType: "L")
                        PlayerStatsBox(playerID: player.player_id, title: "Career World Series", gameType: "W")
                    } //: VSTACK
                } //: SCROLLVIEW
            } //: VSTACK
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .navigationBarTitle(player.name_display_first_last, displayMode: .large)
            .navigationBarHidden(true)
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
            player: Player(position: "RF", name_display_first_last: "Randy Arozarena", name_display_roster: "Arozarena", team_full: "Tampa Bay Rays", player_id: "668227")
        )
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
