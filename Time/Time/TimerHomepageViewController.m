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
@property (nonatomic) NSTimer *timer;
//secondsElapsed
@property (nonatomic) int secondsElapsed;

@end

@implementation TimerHomepageViewController

//To access the singleton: [PresetTimerData sharedModel] + .timerName or .time or .userPresetTimers

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeLabel.text = @"00:00:00";
    
    self.timerPickerData = [PresetTimerData sharedModel].userPresetTimers;
    
    self.timerPickerView.dataSource = self;
    self.timerPickerView.delegate = self;
    
    self.navigationItem.title = @"Timer";
    
    NSLog(@"timer picker data: %@", self.timerPickerData);
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.timerPickerView reloadAllComponents];
    
}

- (IBAction)resetButtonTapped:(UIButton *)sender {
    
    self.timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;
    
}

- (IBAction)startPauseButtonTapped:(UIButton *)sender {
    
    int startTime = [[PresetTimerData sharedModel].userPresetTimerData.time intValue];
    
    self.millisecondsElapsed = 120;
    
    [self startTimer];
    
    
}

-(void)startTimer{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
    
}

-(void)timerFired:(NSTimer *)timer{
    
    self.secondsElapsed -= 1;
    
    //hours
    //minutes
    //seconds
    //int hours = total seconds divided by 3600 to get hours
    int hours = self.secondsElapsed / 60;
    
    //from that remainder you get number of seconds left that weren't part of that hour
    //0-3600
    //From that number you can get the number of minutes by dviding by 60
    //0-60
    
    int remainder_h = self.secondsElapsed % 60; //remaining milliseconds
    
    //if there are seconds left after that that will be the remainder
    
    int minutes =   remainder_h/100 ; // seconds
    int remainder_m = remainder_h % 100; //remaining seconds
    
    int seconds = remainder_m;
    
    
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    
//    CGFloat currentNumber = [self.timeLabel.text floatValue];
//    CGFloat nextNumber = currentNumber - 0.01;
//    
//    self.timeLabel.text = [NSString stringWithFormat:@"%.2f", nextNumber];
//    
//    if (nextNumber == 00.00){
//        
//        [timer invalidate];
//    }
    
    NSLog(@"reaction timer ticking");
    
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
