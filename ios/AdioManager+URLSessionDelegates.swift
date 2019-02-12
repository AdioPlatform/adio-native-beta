//
//  AdioManager+URLSessionDelegates.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

extension AdioManager: URLSessionDownloadDelegate {
  // If the downloadSession hasn't been created yet we need to create it
  func setDownloadSession() {
    if downloadManager.downloadSession == nil {
      downloadManager.downloadSession = downloadSession
    }
  }
  
  func downloadClip(_ clip: Clip) {
    setDownloadSession()
    downloadManager.startDownload(clip)
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    guard let src = downloadTask.originalRequest?.url else { return }
    
    guard let download = downloadManager.activeDownloads.removeValue(forKey: src) else { return }
    
    let destinationURL = download.clips[0].localSrc

    let fileManager = FileManager.default
    
    try? fileManager.removeItem(at: destinationURL!)
    
    do {
      try fileManager.moveItem(at: location, to: destinationURL!)
      
      for clip in download.clips {
        clip.setIsDownloaded()
        
        audioSession?.addClip(clip)
        
        self.sendEvent(withName: AdioManagerConstants.Events.ClipDownloaded, body: clip.data())
      }
      
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    guard let src = downloadTask.originalRequest?.url else { return }
    
    let download = downloadManager.activeDownloads[src]
    
    let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    
    download?.progress = progress
    
    let clips = download?.clips
    
    for clip in clips! {
      self.sendEvent(withName: AdioManagerConstants.Events.ClipDownloadProgress, body: [
        "id": clip.id,
        "progress": progress])
    }
  }
}
