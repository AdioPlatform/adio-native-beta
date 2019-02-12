//
//  Logger.swift
//  AdioManager
//
//  Created by Cole Voss on 1/10/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

var name: String = "ADIO-LOG"

class Logger {
  
  static func debug(_ message: Any...) {
    print("[\(name) DEBUG] ", message)
  }
  
  static func error(_ error: Error) {
    print("[\(name) ERROR] " + error.localizedDescription)
  }
}
