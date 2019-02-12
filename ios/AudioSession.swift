//
//  AudioSession.swift
//  AdioManager
//
//  Created by Cole Voss on 1/10/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

enum AudioSessionStatus: String {
  case Created, Initialized, Ready, Playing, Busy, Destroyed
}

protocol AudioSessionProtocol {
  var engine: AVAudioEngine { get }
  var mixer: AVAudioMixerNode { get }
  var status: AudioSessionStatus { get set }
  var clips: Dictionary<String, Clip> { get set }
  
  func addClip(_ clip: Clip)
}

protocol AudioSessionDelegate: AnyObject {
  // Called when an AudioSession's status is updated
  func statusDidUpdate(_ status: AudioSessionStatus)
  func didAddClip(_ clip: Clip)
  func timeDidUpdate(_ playTime: Float)
}

class AudioSession: AudioSessionProtocol {
  weak var delegate: AudioSessionDelegate?
  
  var engine = AVAudioEngine()
  var mixer = AVAudioMixerNode()
  var offsetTime: AVAudioTime?
  var status = AudioSessionStatus.Created
  var clips: Dictionary<String, Clip> = [:]
  var seekTime: Float = 3
  var updater: CADisplayLink?
  
  
  init?(delegate: AudioSessionDelegate? = nil) {
    self.delegate = delegate
    
    engine.attach(mixer)
    engine.connect(mixer, to: engine.outputNode, format: nil)
    
    updater = CADisplayLink(target: self, selector: #selector(updateUI))
    updater?.add(to: .main, forMode: .default)
    updater?.isPaused = true

    do {
      try engine.start()
      updateStatus(.Created)
      Logger.debug("Engine started")
    } catch {
      Logger.error(error)
    }
  }
  
  
  deinit {
    Logger.debug("AUDIO SESSION DESTROYED")
    updateStatus(.Destroyed)
  }
  
  var allClipsReady: Bool {
    get {
      return clips.allSatisfy({ $0.value.isDownloaded && !$0.value.needsScheduled })
    }
  }
  
  var duration: Float? {
    get {
      return clips.values.map({ $0.endTime }).max()
    }
  }
  
  
  @objc func updateUI() {
    let time = currentTime()
    
    delegate?.timeDidUpdate(time + seekTime)
  }
  
  
  func updateStatus(_ status: AudioSessionStatus) {
    self.status = status

    delegate?.statusDidUpdate(self.status)
  }
  
  
  func updateSeekTime(_ seekTime: Float =  0) {
    self.seekTime = seekTime
    
    prepareClips()
  }
  
  
  func addClip(_ clip: Clip) {
    clips[clip.id] = clip
    
    if !clip.isDownloaded { return }
    
    addClipToGraph(clip)
    clip.prepare(offset: seekTime)
  }
  
  
  func prepareClips() {
    updateStatus(.Busy)
    
    DispatchQueue.global(qos: .userInitiated).async {
      for (_, clip) in self.clips {
        clip.prepare(offset: self.seekTime)
      }
      
      self.updateStatus(.Ready)
    }
  }
  
  
  func addClipToGraph(_ clip: Clip) {
    guard let playerNode = clip.playerNode else { return }
    
    engine.attach(playerNode)
    engine.connect(playerNode, to: mixer, format: nil)
  }
  
  
  func currentTime() -> Float {
    guard let offsetTime = self.offsetTime else { return 0 }
    guard let nowTime = self.engine.outputNode.lastRenderTime else { return 0 }
    
    let offsetSeconds = Float(offsetTime.sampleTime) / Float(offsetTime.sampleRate)
    let nowSeconds = Float(nowTime.sampleTime) / Float(nowTime.sampleRate)
    
    return nowSeconds - offsetSeconds
  }
  
  func setSeekTime(_ time: Float) {
    seekTime = time
    
    delegate?.timeDidUpdate(seekTime)
    
    prepareClips()
  }
  
  
  func stop() {
    updater?.isPaused = true
    
    seekTime += currentTime()
    
    Logger.debug("seekTIme", seekTime)
    
    DispatchQueue.global(qos: .userInitiated).async {
      for (_, clip) in self.clips {
        clip.stop()
        clip.prepare(offset: self.seekTime)
      }
      
      Logger.debug("DONE PREPARING")

    }
    
    delegate?.timeDidUpdate(seekTime)
    updateStatus(.Ready)
  }

  
  func play(_ offset: Float = 0) {
    DispatchQueue.global(qos: .userInitiated).async {
      if !self.engine.isRunning {
        do {
          try self.engine.start()
        } catch {
          Logger.error(error)
        }
      }
      
      self.offsetTime = self.engine.outputNode.lastRenderTime
      
      for (_, clip) in self.clips {
        clip.play(offset: self.seekTime, anchor: (self.offsetTime?.sampleTime)!)
      }

      self.updater?.isPaused = false

      self.updateStatus(.Playing)
    }
  }
}
