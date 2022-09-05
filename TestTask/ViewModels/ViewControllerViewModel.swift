//
//  ViewControllerViewModel.swift
//  TestTask
//
//  Created by Aleks Kravtsova on 2.09.22.
//

import Foundation
import UIKit

protocol ViewControllerViewModelProtocol {
    var songs : [AudioTrack] {get}
    var imagesName : [String] {get}
    var player : Player {get}
    var index : Int {get set}
    
}

final class ViewControllerViewModel : ViewControllerViewModelProtocol {
    
    var index : Int = 0
    
    var player: Player = Player()
    
    var songs: [AudioTrack] {
        [
            AudioTrack(name: "Born to die", ownerName: "Lana Del Ray"),
            AudioTrack(name: "Hills", ownerName: "The Weeknd"),
            AudioTrack(name: "Happier than ever", ownerName: "Billie Eilish"),
        ]
        
    }
    
    var imagesName: [String] {
        ["lana", "weeknd", "billie"]
    }
    
    
}
