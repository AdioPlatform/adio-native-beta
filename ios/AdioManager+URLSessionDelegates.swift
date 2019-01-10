//
//  AdioManager+URLSessionDelegates.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

extension AdioManager: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    
    
    guard let src = downloadTask.originalRequest?.url else { return }
    
//    let download = downloadManager.activeDownloads[src]
//    downloadManager.activeDownloads[src] = nil
    
    let download = downloadManager.activeDownloads.removeValue(forKey: src)
    
    let destinationURL = download?.clip.localSrc
    
    let fileManager = FileManager.default
    
    try? fileManager.removeItem(at: destinationURL!)
    
    do {
      try fileManager.moveItem(at: location, to: destinationURL!)
      
//      download?.clip.isDownloaded = true
      download?.clip.setIsDownloaded()
      
      self.sendEvent(withName: AdioManagerConstants.Events.ClipDownloaded, body: download?.clip.data())
    } catch let error {
      print("Could not copy file to disk: \(error.localizedDescription)")
    }
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    guard let src = downloadTask.originalRequest?.url else { return }
    
    let download = downloadManager.activeDownloads[src]
    
    let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    
    download?.progress = progress
    
    let clipId = download?.clip.id
    
    self.sendEvent(withName: AdioManagerConstants.Events.ClipDownloadProgress, body: [
      "id": clipId!,
      "progress": progress])
  }
}
