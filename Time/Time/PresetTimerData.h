//
//  PresetTimerData.h
//  Time
//
//  Created by Justine Gartner on 8/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PresetTimer.h"
#import <UIKit/UIKit.h>

@interface PresetTimerData : NSObject

@property (nonatomic) NSMutableArray *userPresetTimers;

@property (nonatomic) PresetTimer *userPresetTimerData;
@property (nonatomic) PresetTimer *userUnsavedTimerData;
@property (nonatomic) NSMutableArray *userCountdownTimerData;

@property (nonatomic) UIColor *eggplant;
@property (nonatomic) UIColor *burntOrange;
@property (nonatomic) UIColor *chartreuse;
@property (nonatomic) UIColor *ghostGrey;
@property (nonatomic) UIColor *steelBlueGrey;
@property (nonatomic) UIColor *glacierBlue;


+(UIColor *)makeColorWithRed:(NSInteger)red
                       green:(NSInteger)green
                        blue:(NSInteger)blue;

-(void)initializeData;

+ (PresetTimerData *)sharedModel;

@end
