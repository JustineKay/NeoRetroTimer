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

@interface CountdownViewController ()

@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventNameLabel;

@end

@implementation CountdownViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSTimer *timer;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(countdown)
                                               userInfo:nil
                                                repeats:YES];
}


-(void)countdown {
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
