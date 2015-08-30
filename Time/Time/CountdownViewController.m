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

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@property (nonatomic) AVAudioPlayer *eventCountdownDone;

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
        self.countdownLabel.text = [((NSDate *)event[@"date"]) description];
        self.eventNameLabel.text = event[@"name"];
        
        NSDate *date = event[@"date"];
        NSInteger ti = ((NSInteger)[date timeIntervalSinceNow]);
        NSInteger seconds = ti % 60;
        NSInteger minutes = (ti / 60) % 60;
        NSInteger hours = (ti / 3600) % 24;
        NSInteger days = (ti / 86400);
        
        self.countdownLabel.text = [NSString stringWithFormat:@"%02li days %02li hrs %02li min %02li sec", (long)days, (long)hours, (long)minutes, (long)seconds];
        
      
        if (days == 0 && hours == 0 && minutes == 0 && seconds == 0){
            
            [timer invalidate];
            
            NSString *path = [NSString stringWithFormat:@"%@/Hallelujah-sound-effect.mp3", [[NSBundle mainBundle] resourcePath]];
            NSURL *soundUrl = [NSURL fileURLWithPath:path];
            
            self.eventCountdownDone = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
            [self.eventCountdownDone play];
        }

    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
