//
//  AdioManager+AudioSession.swift
//  AdioManager
//
//  Created by Cole Voss on 1/11/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

import Foundation

extension AdioManager: AudioSessionDelegate {
  @objc
  func play() {
//    Logger.debug("PRESSED PLAY")
  
    audioSession?.play()
  }
  
  @objc
  func stop() {
    audioSession?.stop()
  }
  
  @objc
  func setSeekTime(_ seekTime: Float) {
    audioSession?.setSeekTime(seekTime)
  }
  
  func statusDidUpdate(_ status: AudioSessionStatus) {
    self.sendEvent(withName: AdioManagerConstants.Events.AudioSessionStatusUpdated,
                   body: status.rawValue)
  }
  
  func didAddClip(_ clip: Clip) {
    Logger.debug("ADDED CLIP", clip.id)
  }
  
  func timeDidUpdate(_ playTime: Float) {
    self.sendEvent(withName: AdioManagerConstants.Events.TimeUpdated, body: playTime)
  }
}
