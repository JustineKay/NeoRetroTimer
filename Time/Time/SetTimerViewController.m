//
//  SetTimerViewController.m
//  Time
//
//  Created by Justine Gartner on 8/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "SetTimerViewController.h"
#import "PresetTimerData.h"

@interface SetTimerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userInputTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *setTimerPickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) NSArray *pickerData;
@property (nonatomic) NSArray *pickerHours;
@property (nonatomic) NSArray *pickerMins;
@property (nonatomic) NSArray *pickerSecs;

@property (nonatomic) NSString *userPresetTimer;


@end

@implementation SetTimerViewController

//To access the singleton: [PresetTimerData sharedModel] + .timerName or .time or .userPresetTimers

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pickerHours = @[ @"00", @"01", @"02", @"03", @"04", @"05"];
    self.pickerMins = @[ @"06", @"07", @"08", @"09", @"10", @"11"];
    self.pickerSecs = @[ @"37", @"38", @"39", @"40", @"41", @"042"];
    
    self.pickerData = @[self.pickerHours,
                        self.pickerMins,
                        self.pickerSecs
                        ];
    
    self.setTimerPickerView.dataSource = self;
    self.setTimerPickerView.delegate = self;
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.pickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSString* hour = [self.pickerHours objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString* min = [self.pickerMins objectAtIndex:[pickerView selectedRowInComponent:1]];
    NSString* sec = [self.pickerSecs objectAtIndex:[pickerView selectedRowInComponent:2]];
    [PresetTimerData sharedModel].userPresetTimerData.time = [hour stringByAppendingFormat:@":%@:%@", min, sec];
    
    NSLog(@"time: %@", [PresetTimerData sharedModel].userPresetTimerData.time);
    
    return self.pickerData[component][row];
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {
    
    //if (self.userInputTextField.text != nil) {
        
        [PresetTimerData sharedModel].userPresetTimerData.timerName = self.userInputTextField.text;
        
        NSLog(@"timer name: %@",[PresetTimerData sharedModel].userPresetTimerData.timerName);
        
        NSString *time = [PresetTimerData sharedModel].userPresetTimerData.time;
        NSString *timerName = [PresetTimerData sharedModel].userPresetTimerData.timerName;
        
        self.userPresetTimer = [timerName stringByAppendingFormat:@"          %@", time];
    
        NSLog(@"user preset timer: %@", self.userPresetTimer);
    
        [[PresetTimerData sharedModel].userPresetTimers addObject:self.userPresetTimer];
    
        NSLog(@"user preset timers: %@", [PresetTimerData sharedModel].userPresetTimers);
    //}
    
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
