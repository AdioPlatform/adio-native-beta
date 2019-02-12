//
//  AdioManager.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation
import AVFoundation

struct AdioManagerConstants: Codable {
  struct Events: Codable {
    static let ClipDownloaded = "clipDownloaded"
    static let ClipDownloadProgress = "clipDownloadProgress"
    static let AudioSessionStatusUpdated = "audioSessionStatusUpdated"
    static let TimeUpdated = "timeUpdated"
  }
}

@objc(AdioManager)
class AdioManager: RCTEventEmitter {
  var audioSession: AudioSession?
  
  let downloadManager = DownloadManager()
  
  // Lazily create the download session
  lazy var downloadSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  
  override func supportedEvents() -> [String]! {
    return [
      AdioManagerConstants.Events.ClipDownloaded,
      AdioManagerConstants.Events.ClipDownloadProgress,
      AdioManagerConstants.Events.AudioSessionStatusUpdated,
      AdioManagerConstants.Events.TimeUpdated
    ]
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  

  @objc
  func createAudioSession(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if audioSession != nil {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_AUDIO_SESSION_EXISTS", "An Audio session already exists. You need to destroy it before you create another", error)
      
      return
    }
    
    DispatchQueue.global(qos: .userInitiated).async {
      self.setupAudioSession()
      
      resolve(true)
    }
  }
  
  @objc
  func destroyAudioSession(_ resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    audioSession = nil
    
    resolve(true)
  }
  
  func setupAudioSession() {
    audioSession = AudioSession(delegate: self)
  }
  
  func prepareClip(_ clip: Clip) {
    audioSession?.addClip(clip)
    
    if !clip.isDownloaded {
      downloadClip(clip)
    }
  }
  
  @objc
  func addClip(_ clipData: Dictionary<AnyHashable, Any>, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if audioSession == nil {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_NO_AUDIO_SESSION", "An audio session has not been created to add this clip to", error)
      return
    }
    
    let clip = Clip(clipData)!
    
    resolve(true)
    
    prepareClip(clip)
  }
  
  @objc
  func addClips(_ clipsData: [Dictionary<AnyHashable, Any>], resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    if audioSession == nil {
      let error = NSError(domain: "", code: 200, userInfo: nil)
      reject("E_NO_AUDIO_SESSION", "An audio session has not been created to add this clip to", error)
      return
    }
    
    for clipData in clipsData {
      let clip = Clip(clipData)!
      
      prepareClip(clip)
    }
    
    resolve(true)
  }
}
