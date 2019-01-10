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
  
  var activeDownloads: [URL: Downlad] = [:]
  
  func startDownload(_ clip: Clip) {
    let download = Downlad(clip)
    
    download.task = downloadSession.downloadTask(with: clip.src)
    
    download.task!.resume()
    
    download.isDownloading = true
    
    activeDownloads[download.clip.src] = download
  }
}
