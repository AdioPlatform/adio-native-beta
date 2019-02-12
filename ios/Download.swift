//
//  Download.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class Download {
//  var clip: Clip
  var clips = [Clip]()
  var src: URL
  
  var task: URLSessionDownloadTask?
  var isDownloading = false
  var progress: Float = 0
  
  init(_ clip: Clip) {
//    self.clip = clip
    self.src = clip.src
    self.clips.append(clip)
  }
}
