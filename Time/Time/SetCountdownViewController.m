//
//  SetCountdownViewController.m
//  Time
//
//  Created by Zoufishan Mehdi on 8/29/15.
//  Copyright © 2015 Mike Kavouras. All rights reserved.
//

#import "SetCountdownViewController.h"
#import "PresetTimerData.h"

@interface SetCountdownViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userInputTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *setDatePickerData;
@property (weak, nonatomic) IBOutlet UIButton *eventCountdownButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

//To access the singleton: [PresetTimerData sharedModel] + .userCountdownTimerData + .timerName or .time or .userPresetTimers or .userUnsavedTimerData

@implementation SetCountdownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Set Countdown";
    
    self.userInputTextField.text = @"";
    
}


/*

if ([self.userInputTextField.text isEqualToString:@""]) {
    
    [PresetTimerData sharedModel].userPresetTimerData.timerName = Nil;
    [PresetTimerData sharedModel].userPresetTimerData.time  = Nil;
    
    NSLog(@"Preset Timer: %@", [PresetTimerData sharedModel].userPresetTimerData.time);
    
    [self setTimer:[PresetTimerData sharedModel].userUnsavedTimerData With:self.setTimerPickerView];
    
    NSLog(@"Unsaved Timer: %@", [PresetTimerData sharedModel].userUnsavedTimerData.time);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}else {
    
    [PresetTimerData sharedModel].userPresetTimerData.timerName = self.userInputTextField.text;
    
    NSLog(@"timer name: %@",[PresetTimerData sharedModel].userPresetTimerData.timerName);
    
    [self setTimer:[PresetTimerData sharedModel].userPresetTimerData With:self.setTimerPickerView];
    
    [PresetTimerData sharedModel].userUnsavedTimerData.time = Nil;
    NSLog(@"Unsaved Timer: %@", [PresetTimerData sharedModel].userUnsavedTimerData.time);
    
    NSString *time = [PresetTimerData sharedModel].userPresetTimerData.time;
    NSString *timerName = [PresetTimerData sharedModel].userPresetTimerData.timerName;
    
    self.userPresetTimer = [timerName stringByAppendingFormat:@"     %@", time];
    NSLog(@"user preset timer: %@", self.userPresetTimer);
    
    [[PresetTimerData sharedModel].userPresetTimers insertObject:self.userPresetTimer atIndex:00];
    NSLog(@"user preset timers: %@", [PresetTimerData sharedModel].userPresetTimers);
    
    [PresetTimerData sharedModel].userUnsavedTimerData.time = Nil;
    NSLog(@"unsaved time: %@", [PresetTimerData sharedModel].userUnsavedTimerData.time);
    
    [self dismissViewControllerAnimated:YES completion:nil];
 
 */

- (IBAction)eventCountdownButtonTapped:(id)sender {
    if ([self.userInputTextField.text isEqualToString:@""]) {
        [PresetTimerData sharedModel].userCountdownTimerData.timerName = Nil;
         }
    
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
