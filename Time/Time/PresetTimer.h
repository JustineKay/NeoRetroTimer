//
//  PresetTimer.h
//  Time
//
//  Created by Zoufishan Mehdi on 8/22/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresetTimer : NSObject
@property (nonatomic) NSString *timerName;
@property (nonatomic) NSDate *time;

//singleton with an array of preset timers; picker gets populated based on array;
//NSString stringwithformat take a number and pass it as a string for u

@end
