//
//  PresetTimerData.m
//  Time
//
//  Created by Justine Gartner on 8/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "PresetTimerData.h"

@implementation PresetTimerData

//singleton with an array of preset timers; picker gets populated based on array

+ (PresetTimerData *)sharedModel {
    static PresetTimerData *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        [sharedMyManager initializeData];
    });
    return sharedMyManager;

}

-(void)initializeData{
    
    self.userPresetTimerData = [[PresetTimer alloc] init];
   
    self.userPresetTimers = @[@"Popcorn     00:03:00",
                              @"Laundry-Washer     00:30:00",
                              @"Laundry-Dryer     00:25:00"
                              ].mutableCopy;
    
    self.userUnsavedTimerData = [[PresetTimer alloc] init];
    self.userCountdownTimerData = [[NSMutableArray alloc] init];
    
}

@end
