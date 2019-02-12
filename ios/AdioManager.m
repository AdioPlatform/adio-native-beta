//
//  AdioManager.m
//  AdioManager
//
//  Created by Cole Voss on 1/9/19.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(AdioManager, RCTEventEmitter)

RCT_EXTERN_METHOD(addClip:(NSDictionary *) clipData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(addClips:(NSArray<NSDictionary *> *) clipsData
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(downloadAllClips)

RCT_EXTERN_METHOD(downloadClip:(NSString *) id)

RCT_EXTERN_METHOD(setSeekTime:(float *) seekTime)


RCT_EXTERN_METHOD(play)
RCT_EXTERN_METHOD(stop)

RCT_EXTERN_METHOD(createAudioSession: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(destroyAudioSession: (RCTPromiseResolveBlock)resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
@end
