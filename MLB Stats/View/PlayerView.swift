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
                } //: HSTACK
                .padding(.horizontal, 15)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Hitting Statistics")
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.horizontal, 20)
                    
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
                            Text("Career Hitting")
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
                } //: VSTACK
            } //: VSTACK
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
            }
            .task {
                do {
                    if let stats = try await getCareerHittingStats(gameType: "R", playerID: player.player_id) {
                        hittingStats = [stats]
                        
                        updateCategoryStats()
                    }
                } catch {
                    print("Error", error)
                }
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
            player: Player(position: "CF", name_display_first_last: "Mike Trout", name_display_roster: "Trout", team_full: "Los Angeles Angels", player_id: "545361")
        )
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
