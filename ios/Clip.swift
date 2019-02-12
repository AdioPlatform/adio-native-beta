//
//  Clip.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

class Clip {
  var id: String
  var src: URL!
  var localSrc: URL!
  var isDownloaded: Bool!
  var needsScheduled = true
  var startTime: Float
  
  // MARK: Audio File Setup
  
  var audioFile: AVAudioFile? {
    didSet {
      playerNode = AVAudioPlayerNode()
    }
  }

  var playerNode: AVAudioPlayerNode?

  var audioFormat: AVAudioFormat? {
    get {
      guard let audioFile = audioFile else { return nil }

      return audioFile.fileFormat
    }
  }

  var audioSampleRate: Float {
    get {
      return Float(audioFormat?.sampleRate ?? 44100)
    }
  }

  var audioLengthSeconds: Float {
    get {
      return Float(audioLengthSamples) / audioSampleRate
    }
  }

  var audioLengthSamples: AVAudioFramePosition {
    get {
      return audioFile?.length ?? 0
    }
  }
  
  var endTime: Float {
    get {
      return audioLengthSeconds + startTime
    }
  }
  
  init?(_ clipData: Dictionary<AnyHashable, Any>) {
    guard let id = clipData["id"] as? String else { return nil }
    guard let src = clipData["src"] as? String else { return nil }
    guard let startTime = clipData["startTimeMs"] as? Float else { return nil }
    
    self.id = id
    self.src = URL(string: src)
    self.startTime = startTime / 1000
    
    setLocalSrc()
    setIsDownloaded()
  }
  
  func setLocalSrc() {
    let fileManager = FileManager.default
    
    let documentDirectoryURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
    
    let destinationURL = documentDirectoryURL.appendingPathComponent(self.src.lastPathComponent)
    
    self.localSrc = destinationURL
  }
  
  func setIsDownloaded() {
    let isDownloaded = FileManager.default.fileExists(atPath: self.localSrc.path)
    
    self.isDownloaded = isDownloaded
    
    if isDownloaded {
      setupAudioFile()
    }
  }
  
  func setupAudioFile() {
    do {
      audioFile = try AVAudioFile(forReading: localSrc)
    } catch {
      Logger.error(error)
    }
  }
  
  func startAudioTime(offset: Float = 0) -> AVAudioTime? {
    let start = max(startTime - offset, 0)
    
    let sampleTime = AVAudioFramePosition(start * audioSampleRate)
    let time = AVAudioTime(sampleTime: sampleTime, atRate: Double(audioSampleRate))
    
    return time
  }
  
  func prepare(offset: Float = 0) {
    guard let audioFile = audioFile else { return }
    guard let playerNode = playerNode else { return }
    
    if !shouldPlay(offset: offset) { return }
    
    // Resets the playernode
    stop()
    
    let startingFrame = startFrame(offset: offset)
    let frames = frameCount(offset: offset)
    
    playerNode.scheduleSegment(audioFile, startingFrame: startingFrame, frameCount: frames, at: nil) {
      self.needsScheduled = true
    }
    
    self.needsScheduled = false
  }
  
  
  func stop() {
    playerNode?.stop()
    
    needsScheduled = true
  }
  
  
  func startFrame(offset: Float = 0) -> AVAudioFramePosition {
    let start = max(offset - startTime, 0)
    
    return AVAudioFramePosition(start * audioSampleRate)
  }
  
  func frameCount(offset: Float = 0) -> AVAudioFrameCount {
    let start = startFrame(offset: offset)
    return AVAudioFrameCount(audioLengthSamples - start)
  }
  
  func shouldPlay(offset: Float) -> Bool {
    return endTime > offset
  }
  
  
  func play(offset: Float = 0, anchor: AVAudioFramePosition) {
    guard let playerNode = playerNode else { return }
    
    if !shouldPlay(offset: offset) { return }
    
    let playAt = Float(anchor) + max(startTime - offset, 0) * audioSampleRate
    
    let audioTime = AVAudioTime(sampleTime: AVAudioFramePosition(Double(playAt)), atRate: Double(audioSampleRate))
    
    playerNode.play(at: audioTime)
  }
  
  func data() -> Dictionary<String, Any> {
    return [
      "id": self.id,
//      "name": self.name,
      "src": self.src!.absoluteString,
      "localSrc": self.localSrc!.absoluteString,
      "isDownloaded": self.isDownloaded
    ]
  }
}
