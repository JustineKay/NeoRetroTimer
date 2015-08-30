//
//  TimerHomepageViewController.m
//  Time
//
//  Created by Justine Gartner on 8/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "TimerHomepageViewController.h"
#import "PresetTimerData.h"
#import <AVFoundation/AVFoundation.h>

@interface TimerHomepageViewController ()
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *timerBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *presetTimerLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *startPauseButton;
@property (weak, nonatomic) IBOutlet UIPickerView *timerPickerView;
@property (nonatomic) NSArray *timerPickerData;
@property (nonatomic) NSTimer *timer;
@property (nonatomic) NSString *pausedTime;
@property (nonatomic) NSInteger timeInSeconds;

@property (nonatomic) BOOL *isRunning;

@property (nonatomic) AVAudioPlayer *timerDoneSound;

@end

@implementation TimerHomepageViewController


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        
        // non-selected tab bar image
        UIImage *defaultImage = [[UIImage imageNamed:@"Future"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // selected tab bar image
        UIImage *selectedImage = [[UIImage imageNamed:@"Future Filled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        // set the tab bar item with a title and both images
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Timer" image:defaultImage selectedImage:selectedImage];
        
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.backgroundView.backgroundColor = [PresetTimerData sharedModel].ghostGrey;
    
    self.timerBackgroundView.layer.cornerRadius = 125;
    self.timerBackgroundView.backgroundColor = [PresetTimerData sharedModel].ghostGrey;
    self.timerBackgroundView.layer.borderWidth = 20;
    self.timerBackgroundView.layer.borderColor = [PresetTimerData sharedModel].steelBlueGrey.CGColor;
    
    self.timeLabel.text = @"00:00:00";
    self.timeLabel.textColor = [PresetTimerData sharedModel].eggplant;
    self.presetTimerLabel.text = @"";
    
    [self.startPauseButton setImage:[UIImage imageNamed:@"Start Filled-100"] forState:UIControlStateNormal];
    
    self.presetTimerLabel.textColor = [PresetTimerData sharedModel].burntOrange;
    
    self.timerPickerData = [PresetTimerData sharedModel].userPresetTimers;
    
    self.timerPickerView.dataSource = self;
    self.timerPickerView.delegate = self;
    
    self.navigationItem.title = @"Timer";
    
    self.isRunning = FALSE;
    
    NSLog(@"timer picker data: %@", self.timerPickerData);
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self.timerPickerView reloadAllComponents];
    [self.timer invalidate];
    self.pausedTime = Nil;
    
    if ([PresetTimerData sharedModel].userUnsavedTimerData.time == Nil) {
        
        [self updateTimeLabel];
        
    } else{
    
        self.timeLabel.text = [PresetTimerData sharedModel].userUnsavedTimerData.time;
        self.presetTimerLabel.text = @"";
    
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
        [pickerLabel setFont:[UIFont fontWithName:@"PrintBold" size:22.0]];
        
        [pickerLabel setTextColor:[PresetTimerData sharedModel].eggplant];
        
    }
    
    [pickerLabel setText:[self.timerPickerData objectAtIndex:row]];
    
    return pickerLabel;
    
}

- (IBAction)resetButtonTapped:(UIButton *)sender {
    
    self.pausedTime = Nil;
    [PresetTimerData sharedModel].userUnsavedTimerData.time = Nil;
    [self updateTimeLabel];
}

- (IBAction)startPauseButtonTapped:(UIButton *)sender {

    if (self.isRunning) {
        [self.timer invalidate];
        self.isRunning = FALSE;
        self.pausedTime = self.timeLabel.text;
        [self.startPauseButton setImage:[UIImage imageNamed:@"Start Filled-100"] forState:UIControlStateNormal];
        
        
    }else {
        
        [self updateTimeLabel];

        [self startTimer];
        
        [self.startPauseButton setImage:[UIImage imageNamed:@"Pause Filled-O"] forState:UIControlStateNormal];
        
        self.isRunning = TRUE;
    
    }
}

- (void)updateTimeLabel{
    
    if (self.pausedTime != Nil) {
        self.timeLabel.text = self.pausedTime;
        [self setNumericalValueOfTime:self.pausedTime];
    
    }else if ([PresetTimerData sharedModel].userUnsavedTimerData.time != Nil) {
        
        self.presetTimerLabel.text = @"";
        self.timeLabel.text = [PresetTimerData sharedModel].userUnsavedTimerData.time;
        [self setNumericalValueOfTime:[PresetTimerData sharedModel].userUnsavedTimerData.time];
        
    }else {
        
        [self setPresetTimer:[PresetTimerData sharedModel].userPresetTimerData With:self.timerPickerView];
        
        self.presetTimerLabel.text = [PresetTimerData sharedModel].userPresetTimerData.timerName;
        self. timeLabel.text = [PresetTimerData sharedModel].userPresetTimerData.time;
        
        [self setNumericalValueOfTime:[PresetTimerData sharedModel].userPresetTimerData.time];
    }
    
}

-(void)setPresetTimer:(PresetTimer *)timer With: (UIPickerView *)pickerView{
    
    NSInteger selectedRow = [pickerView selectedRowInComponent:0];
    NSString *selection = [PresetTimerData sharedModel].userPresetTimers[selectedRow];
    NSArray *separatedComponents = [selection componentsSeparatedByString:@"     "];
    
    timer.time = separatedComponents[1];
    
    self.timeLabel.text = timer.time;
    
    
    timer.timerName = separatedComponents[0];
    
    self.presetTimerLabel.text = timer.timerName;
    
}

-(void)setNumericalValueOfTime: (NSString *)time{
    
    NSString *goTime;
    
    goTime = time;
    
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
    
    self.timeInSeconds = goTimeInSeconds;
    
}

-(void)startTimer{
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    self.timer = timer;
    
}

-(void)timerFired:(NSTimer *)timer{
    
    self.timeInSeconds -= 1;
    
    //hours
    //minutes
    //seconds
    //int hours = total seconds divided by 3600 to get hours
    NSInteger hours = self.timeInSeconds / 3600;
    
    //from that remainder you get number of seconds left that weren't part of that hour
    //0-3600
    NSInteger remainder_h = self.timeInSeconds % 3600; //remaining milliseconds
    
    //From that number you can get the number of minutes by dviding by 60
    //0-60
    NSInteger minutes =   remainder_h/60 ; // seconds
    NSInteger remainder_m = remainder_h % 60; //remaining seconds
    
    //if there are seconds left after that that will be the remainder
    NSInteger seconds = remainder_m;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, seconds];
    
    
    if (hours <= 0 && minutes <= 0 && seconds <= 0){
        
                [timer invalidate];
        //sound
        NSString *path = [NSString stringWithFormat:@"%@/Coo-coo-clock-sound.mp3", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        
        self.timerDoneSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
       [self.timerDoneSound play];
        
        //background color animation
        [UIView animateWithDuration:1.0 animations:^{
            self.timerBackgroundView.backgroundColor = [PresetTimerData sharedModel].chartreuse;
        }];
        
//        [UIView animateWithDuration:1.0 animations:^{
//            self.resetButton.tintColor = [PresetTimerData sharedModel].eggplant;
//        }];
    }
    
    NSLog(@"reaction timer ticking");
    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return self.timerPickerData.count;
}


- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.timerPickerData[row];
}

@end
