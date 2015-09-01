//
//  CountdownViewController.m
//  Time
//
//  Created by Zoufishan Mehdi on 8/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "CountdownViewController.h"
#import "SetCountdownViewController.h"
#import "PresetTimerData.h"
#import <AVFoundation/AVFoundation.h>

@interface CountdownViewController ()

@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *minsLabel;
@property (weak, nonatomic) IBOutlet UILabel *secsLabel;

@property (nonatomic) AVAudioPlayer *eventCountdownDone;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *countdownLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *DaysHrsMinsSecsLabels;

@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation CountdownViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        // non-selected tab bar image
        UIImage *defaultImage = [[UIImage imageNamed:@"Overtime"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // selected tab bar image
        UIImage *selectedImage = [[UIImage imageNamed:@"Overtime Filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // set the tab bar item with a title and both images
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Countdown" image:defaultImage selectedImage:selectedImage];
        
        return self;
    }
    return nil;
}

- (void)viewDidAppear:(BOOL)animated{

    self.backgroundView.backgroundColor = [PresetTimerData sharedModel].ghostGrey;
    [self setUpEventLabelUI];
    [self setUpDaysHrsMinsSecsLabelsUI];
    [self setUpCountdownLabelsUI];
    
    
}

- (void)setUpCountdownLabelsUI {
    NSArray *labels = self.countdownLabels;
    
    for (UILabel *label in labels) {
        label.font = [UIFont fontWithName:@"DigitaldreamFat" size:28.0];
        label.textColor = [PresetTimerData sharedModel].eggplant;
        label.layer.borderWidth = 15.0;
        label.layer.borderColor = [PresetTimerData sharedModel].steelBlueGrey.CGColor;
        label.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
        label.layer.cornerRadius = 10.0;
        
    }
}

- (void)setUpDaysHrsMinsSecsLabelsUI {
    NSArray *labels = self.DaysHrsMinsSecsLabels;
    
    for (UILabel *label in labels) {
        label.font = [UIFont fontWithName:@"PrintClearly" size:22.0];
        label.textColor = [PresetTimerData sharedModel].burntOrange;
    }
}

-(void)setUpEventLabelUI{
    
    self.eventNameLabel.textColor = [PresetTimerData sharedModel].burntOrange;
    self.eventNameLabel.layer.borderColor = [PresetTimerData sharedModel].chartreuse.CGColor;
    self.eventNameLabel.layer.borderWidth = 3.0;
    self.eventNameLabel.layer.cornerRadius = 10;
    self.eventNameLabel.font = [UIFont fontWithName:@"PrintBold" size:22.0];
    
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(timerFired:)
                                               userInfo:nil
                                                repeats:YES];
    
}


-(void)timerFired:(NSTimer *)timer {
    
    NSDictionary *event = [[PresetTimerData sharedModel].userCountdownTimerData lastObject];
    
      if (event != nil) {

        NSDate *date = event[@"date"];
        NSInteger ti = ((NSInteger)[date timeIntervalSinceNow]);
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        NSInteger hours = (ti / 3600) % 24;
        NSInteger days = (ti / 86400);
        
        self.daysLabel.text = [NSString stringWithFormat:@"%02li", (long)days];
        self.hoursLabel.text = [NSString stringWithFormat:@"%02li", (long)hours];
        self.minsLabel.text = [NSString stringWithFormat:@"%02li", (long)minutes];
        self.secsLabel.text = [NSString stringWithFormat:@"%02li", (long)seconds];
      
        if (days <= 00 && hours <= 00 && minutes <= 00 && seconds <= 00){
            
            [timer invalidate];
            
            
            NSString *path = [NSString stringWithFormat:@"%@/Hallelujah-sound-effect.mp3", [[NSBundle mainBundle] resourcePath]];
            NSURL *soundUrl = [NSURL fileURLWithPath:path];
            
            self.eventCountdownDone = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            [self.eventCountdownDone play];
            
            
//            //label color changes
//            [UIView animateWithDuration:2.0 animations:^{
//                NSArray *labels = self.countdownLabels;
//                
//                for (UILabel *label in labels) {
//                    label.textColor = [PresetTimerData sharedModel].chartreuse;
//                    label.layer.borderColor = [PresetTimerData sharedModel].glacierBlue.CGColor;
//                    label.layer.backgroundColor = [PresetTimerData sharedModel].eggplant.CGColor;
//                }
//            }];
//            
//            //entire background view color animation
//            [UIView animateWithDuration:5.0 animations:^{
//                self.backgroundView.backgroundColor = [PresetTimerData sharedModel].burntOrange;
//            }];
//            
//            
//            [UIView animateWithDuration:3.5 animations:^{
//                self.backgroundView.backgroundColor = [PresetTimerData sharedModel].chartreuse;
//            }completion:^(BOOL finished) {
//                
//                NSArray *labels = self.countdownLabels;
//                
//                for (UILabel *label in labels) {
//                    label.textColor = [PresetTimerData sharedModel].eggplant;
//                    label.layer.borderColor = [PresetTimerData sharedModel].steelBlueGrey.CGColor;
//                    label.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
//                }
//                
//                self.backgroundView.backgroundColor = [PresetTimerData sharedModel].ghostGrey;
//            }];
            
            
            
            [UIView animateWithDuration:2.0 animations:^{
                self.daysLabel.layer.backgroundColor = [PresetTimerData sharedModel].chartreuse.CGColor;
                self.hoursLabel.layer.backgroundColor = [PresetTimerData sharedModel].chartreuse.CGColor;
                self.minsLabel.layer.backgroundColor = [PresetTimerData sharedModel].chartreuse.CGColor;
                self.secsLabel.layer.backgroundColor = [PresetTimerData sharedModel].chartreuse.CGColor;
            }];
            
            [UIView animateWithDuration:5.0 animations:^{
                self.backgroundView.backgroundColor = [PresetTimerData sharedModel].glacierBlue;
            }];
            
            [UIView animateWithDuration:3.5 animations:^{
                self.backgroundView.backgroundColor = [PresetTimerData sharedModel].eggplant;
            }];
            
            [UIView animateWithDuration:5.0 animations:^{
                self.daysLabel.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
                self.hoursLabel.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
                self.minsLabel.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
                self.secsLabel.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
                
                self.backgroundView.backgroundColor = [PresetTimerData sharedModel].ghostGrey;
            }];
            
//            [UIView animateWithDuration:5.0 animations:^{
//                self.backgroundView.backgroundColor = [PresetTimerData sharedModel].eggplant;
//            }completion:^(BOOL finished) {
//                self.daysLabel.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
//                self.hoursLabel.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
//                self.minsLabel.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
//                self.secsLabel.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
//                
//                self.backgroundView.backgroundColor = [PresetTimerData sharedModel].ghostGrey;
//            }];
            
            
        }
          
    }

}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
