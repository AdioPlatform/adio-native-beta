//
//  Clip.swift
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

class Clip {
  var id: String
  var name: String
  var src: URL!
  var localSrc: URL!
  var isDownloaded: Bool!
  
  init?(_ clipData: Dictionary<AnyHashable, Any>) {
    guard let id = clipData["id"] as? String else { return nil }
    guard let name = clipData["name"] as? String else { return nil }
    guard let src = clipData["src"] as? String else { return nil }
    
    self.id = id
    self.name = name
    self.src = URL(string: src)
    
    setLocalSrc()
    setIsDownloaded()
  }
  
  func setLocalSrc() {
    let fileManager = FileManager.default
    
    let documentDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    let destinationURL = documentDirectoryURL.appendingPathComponent(self.src.lastPathComponent)
    
    self.localSrc = destinationURL
  }
  
  func setIsDownloaded() {
    let isDownloaded = FileManager.default.fileExists(atPath: self.localSrc.path)
    
    self.isDownloaded = isDownloaded
  }
  
  func data() -> Dictionary<String, Any> {
    return [
      "id": self.id,
      "name": self.name,
      "src": self.src!.absoluteString,
      "localSrc": self.localSrc!.absoluteString,
      "isDownloaded": self.isDownloaded
    ]
  }
}
