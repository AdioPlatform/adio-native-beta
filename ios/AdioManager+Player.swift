//
//  AdioManager+Player.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

extension AdioManager {
//  var canPlay: Bool {
//    get {
//      return clips.allSatisfy({ $0.value.isDownloaded })
//    }
//  }
//
//  
//  var lastRenderTime: AVAudioTime? {
//    get {
//      return engine.outputNode.lastRenderTime
//    }
//  }
//  
//  var currentPositionInSeconds: TimeInterval {
//    get {
//      guard let offsetTime = offsetTime else { return 0 }
//      guard let lastRenderTime = engine.outputNode.lastRenderTime else { return 0 }
//      let frames = lastRenderTime.sampleTime - offsetTime.sampleTime
//      return Double(frames) / offsetTime.sampleRate
//    }
//  }
//  
//  func setupPlaybackAudioSession() {
//    if #available(iOS 10.0, *) {
//      try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.duckOthers, .defaultToSpeaker])
//    } else {
//      AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
//    }
//  }
//  
//  func setupAudio() {
//    if !canPlay { return }
//    
//    engine.attach(mixer)
//    engine.connect(mixer, to: engine.outputNode, format: nil)
//    
//    engine.prepare()
//  }
//  
//  func prepare() {
//    Logger.debug("PREPARE")
////    DispatchQueue.global(qos: .background).async {
//      Logger.debug("PREPARE QUEUE")
////      self.engine.reset()
//      
//      self.engine.attach(self.mixer)
//      self.engine.connect(self.mixer, to: self.engine.outputNode, format: nil)
//      
//      do {
//        try self.engine.start()
//        
//        self.prepareClips()
//        
//        Logger.debug("PLAYING??", self.engine.isRunning)
//      } catch {
//        Logger.error(error)
//        
//        return
//      }
////    }
//  }
//  
//  func prepareClips() {
//    for (_, clip) in clips {
////      guard let playerNode = clip.playerNode else {
////        Logger.debug("NO PLAYER NODE I GUESS ")
////        return
////      }
//      
//      Logger.debug("AUDIO FORMAT", clip.audioFormat!)
//      
//      
//      
//      engine.attach(clip.playerNode!)
//      engine.connect(clip.playerNode!, to: mixer, format: nil)
////
////      clip.playerNode!.scheduleFile(clip.audioFile!, at: nil, completionHandler: nil)
////      clip.playerNode!.play()
//      
//      clip.play()
//    }
//  }
//  
//  @objc
//  func stop() {
//    
//  }
//  
//  
//  @objc
//  func play() {
////    setupPlaybackAudioSession()
//    Logger.debug("PLAY PRESSED")
//    prepare()
//  }
}


//func createStartTime() -> AVAudioTime? {
//  var time:AVAudioTime?
//
//  if let lastPlayer = self.trackPlayerDictionary[lastPlayerKey] {
//    if let sampleRate = lastPlayer.file?.processingFormat.sampleRate {
//      var sampleTime = AVAudioFramePosition(shortStartDelay * sampleRate )
//      time = AVAudioTime(hostTime: mach_absolute_time(), sampleTime: sampleTime, atRate: sampleRate)
//
//    }
//
//  }
//
//  return time
//
//}
