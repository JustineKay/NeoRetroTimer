//
//  PresetTimerData.h
//  Time
//
//  Created by Justine Gartner on 8/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresetTimer.h"

@interface PresetTimerData : NSObject

@property (nonatomic) NSMutableArray *userPresetTimers;

@property (nonatomic) PresetTimer *userPresetTimerData;
@property (nonatomic) PresetTimer *userUnsavedTimerData;

-(void)initializeData;

+ (PresetTimerData *)sharedModel;

@end
