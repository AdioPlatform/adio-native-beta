//
//  DownloadManager.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class DownloadManager {
  var downloadSession: URLSession!
  
  var activeDownloads: [URL: Download] = [:]
  
  func startDownload(_ clip: Clip) {
    if activeDownloads[clip.src] != nil {
      activeDownloads[clip.src]?.clips.append(clip)
      return
    }
    
    let download = Download(clip)
    
//    download.task = downloadSession.downloadTask(with: clip.src)
    download.task = downloadSession.downloadTask(with: download.src)
    download.task!.resume()
    
    download.isDownloading = true
    
    activeDownloads[download.src] = download
  }
}
