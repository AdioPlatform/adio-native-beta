//
//  Download.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class Downlad {
  var clip: Clip
  
  var task: URLSessionDownloadTask?
  var isDownloading = false
  var progress: Float = 0
  
  init(_ clip: Clip) {
    self.clip = clip
  }
}
