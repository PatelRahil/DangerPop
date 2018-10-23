//
//  Sound.swift
//  Two Color Animate Background
//
//  Created by Seth Kujawa on 10/21/18.
//  Copyright © 2018 Abhishek Verma. All rights reserved.
//

import Foundation
import AVFoundation

class Sound {
    
    var audioPlayerPop: AVAudioPlayer
    var audioPlayerDing: AVAudioPlayer
    
    init(){
        
        audioPlayerPop = AVAudioPlayer()
        audioPlayerDing = AVAudioPlayer()
        
        do {
            audioPlayerPop = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "pop", ofType: "mp3")!))
            audioPlayerPop.prepareToPlay()
            audioPlayerPop.volume = 1.0
            audioPlayerDing = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "ding", ofType: "mp3")!))
            audioPlayerDing.prepareToPlay()
        }catch {
            print(error)
        }
        
    }
    
    
    func play(type: String) {
        if type == "pop"{
            audioPlayerPop.play()
        }
        if type == "ding"{
            audioPlayerDing.play()
        }
    }
}
