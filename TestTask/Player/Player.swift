//
//  Player.swift
//  TestTask
//
//  Created by Aleks Kravtsova on 2.09.22.
//

import Foundation
import AVFoundation
import UIKit

protocol PlayerDataSource : AnyObject {
    var currentTime : Float {get}
    var duration : Float {get}
}

final class Player {
    
    private var player : AVPlayer?
    private var track : AudioTrack?
 

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func playTrack(with track : AudioTrack){
        player = nil
        self.track = track
        
        guard  let path = Bundle.main.path(forResource: track.name, ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)
        
        let item = AVPlayerItem(asset: AVAsset(url: url))
        player = AVPlayer(playerItem: item)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        player?.play()
    }
    
    @objc private func playerDidFinishPlaying(sender: Notification){
        nextButtonDidTap()
    }
    
    
}
                                                   

//MARK: - extension ViewControllerDelegate
extension Player : ViewControllerDelegate {
    
    func nextButtonDidTap() {
        player?.seek(to: .zero)
        player?.play()
    
    }
    
    func backwardButtonDidTap() {
        player?.seek(to: .zero)
        player?.play()
       
    }
    
    
    
    func playPauseDidTap() {
        if let player = player {
            switch player.timeControlStatus {
            case .playing:
                player.pause()
            case .paused:
                player.play()
           default:
                return
            }
        }
    }
    
}


extension Player : PlayerDataSource {
    var currentTime : Float {
        if let player = player {
            return Float(CMTimeGetSeconds(player.currentTime()))
        }
       
        return 0.0
       
   }
    
    var duration : Float {
        if let player = player,
           let current = player.currentItem {
            return Float(CMTimeGetSeconds(current.duration))
        }
        
        return 0.0
     
    }
}

