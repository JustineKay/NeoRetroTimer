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
@property (nonatomic) NSInteger secondsElapsed;

@property (nonatomic) BOOL *isRunning;

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
    
    self.isRunning = FALSE;
    
    NSLog(@"timer picker data: %@", self.timerPickerData);
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.timerPickerView reloadAllComponents];
    
    if ([PresetTimerData sharedModel].userUnsavedTimerData.time == Nil) {
        self.timeLabel.text = @"00:00:00";
    } else{
    
        self.timeLabel.text = [PresetTimerData sharedModel].userUnsavedTimerData.time;
        self.presetTimerLabel.text = @"";
    
    }
}

- (IBAction)resetButtonTapped:(UIButton *)sender {
    
    self.timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;
    
}

- (void)updateTimerLabel{
    
    NSInteger selectedRow = [self.timerPickerView selectedRowInComponent:0];
    NSString *selection = [PresetTimerData sharedModel].userPresetTimers[selectedRow];
    NSArray *separatedComponents = [selection componentsSeparatedByString:@"     "];
    
    [PresetTimerData sharedModel].userPresetTimerData.time = separatedComponents[1];
    
    self.timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;

    
    [PresetTimerData sharedModel].userPresetTimerData.timerName = separatedComponents[0];
    
    self.presetTimerLabel.text = [PresetTimerData sharedModel].userPresetTimerData.timerName;

}

- (IBAction)startPauseButtonTapped:(UIButton *)sender {
    
    [self updateTimerLabel];

    if (self.isRunning) {
        [self.timer invalidate];
        self.isRunning = FALSE;
        //[PresetTimerData sharedModel].userPresetTimerData.time = self.timeLabel.text;
        
    }else {
        
        NSString *goTime = [PresetTimerData sharedModel].userPresetTimerData.time;
        NSLog(@"Go time: %@", goTime);
        
        NSArray *goTimeComponents = [goTime componentsSeparatedByString:@":"];
        NSLog(@"%@", goTimeComponents);
        
        NSString *hrs = goTimeComponents[0];
        NSString *mns = goTimeComponents[1];
        NSString *scs = goTimeComponents[2];
        NSInteger hrsInt = [hrs integerValue];
        NSInteger mnsInt = [mns integerValue];
        NSInteger scsInt = [scs integerValue];
        
        NSInteger hrsIntInSec = hrsInt * 3600;
        
        NSInteger mnsIntInSec = mnsInt * 60;
        
        NSInteger goTimeInSeconds = hrsIntInSec + mnsIntInSec + scsInt;
        
        NSLog(@"hrs: %ld, mns: %ld, scs: %ld", hrsIntInSec, mnsIntInSec, scsInt);
        NSLog( @"go time in seconds: %ld", goTimeInSeconds);
        NSLog(@"%@", [PresetTimerData sharedModel].userPresetTimerData.time);
        NSLog(@"timer name: %@", [PresetTimerData sharedModel].userPresetTimerData.timerName);
        
        self.secondsElapsed = goTimeInSeconds;
        
        [self startTimer];
        
        self.isRunning = TRUE;
    
    }
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
    NSInteger hours = self.secondsElapsed / 3600;
    
    //from that remainder you get number of seconds left that weren't part of that hour
    //0-3600
    NSInteger remainder_h = self.secondsElapsed % 3600; //remaining milliseconds
    
    //From that number you can get the number of minutes by dviding by 60
    //0-60
    NSInteger minutes =   remainder_h/60 ; // seconds
    NSInteger remainder_m = remainder_h % 60; //remaining seconds
    
    //if there are seconds left after that that will be the remainder
    NSInteger seconds = remainder_m;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    
    
    if (hours == 0 && minutes == 0 && seconds == 0){
        
                [timer invalidate];
    }
    
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
    
//    if ([[PresetTimerData sharedModel].userPresetTimerData.timerName isEqualToString:@""]) {
//        
//        self.presetTimerLabel.text = @"";
//        self.timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;
//        
//    }else if ([[PresetTimerData sharedModel].userPresetTimerData.time isEqualToString:@"00:00:00"]){
//        
//        NSString *userChoice = [self.timerPickerData objectAtIndex:[pickerView selectedRowInComponent:0]];
//        NSArray *separatedComponents = [userChoice componentsSeparatedByString:@"     "];
//        
//        [PresetTimerData sharedModel].userPresetTimerData.timerName = separatedComponents[0];
//        
//        self.presetTimerLabel.text = [PresetTimerData sharedModel].userPresetTimerData.timerName;
//        
//        [PresetTimerData sharedModel].userPresetTimerData.time = separatedComponents[1];
//        
//        self.timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;
//        
//    }else {
//        
//        
//    }
    
//    [self updateTimerLabel];
    return self.timerPickerData[row];
}

- (void)startTimer:(PresetTimer *)timer {
    // update timer lables
    // start timer
    
    self.presetTimerLabel.text = timer.timerName;
    self.timeLabel.text = timer.time;
    
    // create a new timer with timer.time as the time
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
