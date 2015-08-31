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

@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@end


@implementation SetCountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.setDatePickerData setValue:[PresetTimerData sharedModel].burntOrange forKey:@"textColor"];
    self.backgroundView.backgroundColor = [PresetTimerData sharedModel].ghostGrey;
    self.eventCountdownButton.titleLabel.font = [UIFont fontWithName:@"PrintBold" size:22.0];
    self.eventCountdownButton.tintColor = [PresetTimerData sharedModel].eggplant;
    self.eventCountdownButton.layer.borderWidth = 2.5;
    self.eventCountdownButton.layer.borderColor = [PresetTimerData sharedModel].chartreuse.CGColor;
    self.eventCountdownButton.layer.cornerRadius = 10.0;
    self.eventCountdownButton.layer.backgroundColor = [PresetTimerData sharedModel].burntOrange.CGColor;
    
    self.userInputTextField.font = [UIFont fontWithName:@"PrintBold" size:18.0];
    
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

@end
