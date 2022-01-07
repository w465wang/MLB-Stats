//
//  PlayerView.swift
//  MLB Stats
//
//  Created by William Wang on 2022-01-06.
//

import SwiftUI

struct PlayerView: View {
    
    var player: Player
    
    var body: some View {
        Text(player.name_display_first_last)
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(
            player: Player(position: "CF", name_display_first_last: "Mike Trout", team_full: "Los Angeles Angels", player_id: "545361")
        )
    }
}
