//
//  TimerHomepageViewController.m
//  Time
//
//  Created by Justine Gartner on 8/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "TimerHomepageViewController.h"
#import "PresetTimerData.h"

@interface TimerHomepageViewController ()
@property (weak, nonatomic) IBOutlet UIView *timerBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *presetTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *startPauseButton;
@property (weak, nonatomic) IBOutlet UIPickerView *timerPickerView;
@property (nonatomic) NSArray *timerPickerData;

@end

@implementation TimerHomepageViewController

//NSString stringwithformat take a number and pass it as a string for timer counter

//To access the singleton: [PresetTimerData sharedModel] + .timerName or .time or .userPresetTimers

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeLabel.text = @"00:00:00";
    
    self.timerPickerData = [PresetTimerData sharedModel].userPresetTimers;
    
    self.timerPickerView.dataSource = self;
    self.timerPickerView.delegate = self;
    
    NSLog(@"timer picker data: %@", self.timerPickerData);
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.timerPickerView reloadAllComponents];
    
}

- (IBAction)resetButtonTapped:(UIButton *)sender {
}

- (IBAction)startPauseButtonTapped:(UIButton *)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.timerPickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if ([[PresetTimerData sharedModel].userPresetTimerData.timerName isEqualToString:@""]) {
        
        self.presetTimerLabel.text = @"";
        self.timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;
        
    }else if ([[PresetTimerData sharedModel].userPresetTimerData.time isEqualToString:@"00:00:00"]){
        
        NSString *userChoice = [self.timerPickerData objectAtIndex:[pickerView selectedRowInComponent:0]];
        NSArray *separatedComponents = [userChoice componentsSeparatedByString:@"     "];
        
        [PresetTimerData sharedModel].userPresetTimerData.timerName = separatedComponents[0];
        
        self.presetTimerLabel.text = [PresetTimerData sharedModel].userPresetTimerData.timerName;
        
        [PresetTimerData sharedModel].userPresetTimerData.time = separatedComponents[1];
        
        self.timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;
        
    }else {
        
        NSString *userChoice = [self.timerPickerData objectAtIndex:[pickerView selectedRowInComponent:0]];
        NSArray *separatedComponents = [userChoice componentsSeparatedByString:@"     "];
        
        [PresetTimerData sharedModel].userPresetTimerData.timerName = separatedComponents[0];
        
        self.presetTimerLabel.text = [PresetTimerData sharedModel].userPresetTimerData.timerName;
        
        [PresetTimerData sharedModel].userPresetTimerData.time = separatedComponents[1];
        
        self.timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;
        
    }
    
    return self.timerPickerData[row];
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
