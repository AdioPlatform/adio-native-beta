//
//  AdioManager.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

struct AdioManagerConstants: Codable {
  struct Events: Codable {
    static let ClipDownloaded = "clipDownloaded"
    static let ClipDownloadProgress = "clipDownloadProgress"
  }
}

@objc(AdioManager)
class AdioManager: RCTEventEmitter {
  let downloadManager = DownloadManager()
  
  var clips: [String: Clip] = [:]
  
  lazy var downloadSession: URLSession = {
    let configuration = URLSessionConfiguration.default
    return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
  }()
  
  override func supportedEvents() -> [String]! {
    return [
      AdioManagerConstants.Events.ClipDownloaded,
      AdioManagerConstants.Events.ClipDownloadProgress
    ]
  }
  
  func setDownloadSession() {
    if downloadManager.downloadSession == nil {
      downloadManager.downloadSession = downloadSession
    }
  }
  
  func downloadFile(_ id: String) {
    guard let clip = clips[id] else { return }
    
    if clip.isDownloaded { return }
    
    setDownloadSession()
    
    downloadManager.startDownload(clip)
  }
  
  @objc
  func addClip(_ clipData: Dictionary<AnyHashable, Any>, resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    let clip = Clip(clipData)!
    
    clips[clip.id] = clip
    
    resolve(clip.data())
  }
  
  @objc
  func addClips(_ clipsData: [Dictionary<AnyHashable, Any>], resolver resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) {
    var newClips: [Dictionary<AnyHashable, Any>] = [];
    
    for clipData in clipsData {
      let clip = Clip(clipData)!
      
      clips[clip.id] = clip
      
      newClips.append(clip.data())
    }
    
    resolve(newClips)
  }
  
  @objc
  func downloadAllClips() {
    for (_, clip) in clips {
      downloadFile(clip.id)
    }
  }
  
  @objc func downloadClip(_ id: String) {
    downloadFile(id)
  }
}
