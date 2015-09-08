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
    
    self.eggplant = [PresetTimerData makeColorWithRed:67 green:28 blue:93];
    self.burntOrange = [PresetTimerData makeColorWithRed:224 green:89 blue:21];
    self.chartreuse = [PresetTimerData makeColorWithRed:205 green:212 blue:34];
    self.ghostGrey = [PresetTimerData makeColorWithRed:230 green:233 blue:240];
    self.glacierBlue = [PresetTimerData makeColorWithRed:194 green:221 blue:230];
    self.steelBlueGrey = [PresetTimerData makeColorWithRed:188 green:203 blue:222];
    
}

+(UIColor *)makeColorWithRed:(NSInteger)red
                        green:(NSInteger)green
                         blue:(NSInteger)blue {
    return [UIColor colorWithRed:red / 255.0
                           green:green / 255.0
                            blue:blue / 255.0
                           alpha:1.0];
}



@end
