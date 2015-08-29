//
//  SetCountdownViewController.m
//  Time
//
//  Created by Zoufishan Mehdi on 8/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "SetCountdownViewController.h"
#import "CountdownViewController.h"
#import "PresetTimerData.h"

@interface SetCountdownViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userInputTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *setDatePickerData;
@property (weak, nonatomic) IBOutlet UIButton *eventCountdownButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (nonatomic) NSArray *datePickerData;
@property (nonatomic) NSArray *datePickerDays;
@property (nonatomic) NSArray *datePickerHours;
@property (nonatomic) NSArray *datePickerMins;
@property (nonatomic) NSArray *datePickerSecs;

@end

//To access the singleton: [PresetTimerData sharedModel] + .userCountdownTimerData + .timerName or .time or .userPresetTimers or .userUnsavedTimerData

@implementation SetCountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Set Countdown";
    
    self.userInputTextField.text = @"";
    
}


- (IBAction)eventCountdownButtonTapped:(id)sender {
    NSLog(@"%@", self.setDatePickerData.date);
    
   
        NSDictionary *countdownData = @{
                                        @"name" : self.userInputTextField.text,
                                        @"date" : self.setDatePickerData.date
                                        };
    
        [[PresetTimerData sharedModel].userCountdownTimerData addObject:countdownData];
    
        [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cancelButtonTapped:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
