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

//To access the singleton: [PresetTimerData sharedModel] + .userCountdownTimerData + .timerName or .time or .userPresetTimers or .userUnsavedTimerData

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Set Timer";
    
    self.userInputTextField.text = @"";
    
    NSMutableArray *hours = @[@"00"].mutableCopy;
    NSMutableArray *mins = @[@"00"].mutableCopy;
    NSMutableArray *secs = @[@"00"].mutableCopy;
    
    NSInteger integer = 0;
    
    for (int i = 0; i < 99; i++) {
        
        integer += 1;
        
        NSLog(@"%ld", integer);
        
        NSString *digit = [NSString stringWithFormat:@"%ld", integer];
        
        if ([digit integerValue] < 10) {
            
            NSString *zero = @"0";
            
            digit = [zero stringByAppendingString:digit];
        };
        
        [hours addObject:digit];
        [mins addObject:digit];
        [secs addObject:digit];
        
    }
    
    NSLog(@"hours: %@/n", hours);
    NSLog(@"mins: %@/n", mins);
    NSLog(@"secs: %@/n", secs);
    
    self.pickerHours = hours;
    self.pickerMins = mins;
    self.pickerSecs = secs;
    
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

    
    return [self.pickerData[component] count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    //[self setTimer:[PresetTimerData sharedModel].userPresetTimerData With:pickerView];
    
    //NSLog(@"time: %@", [PresetTimerData sharedModel].userPresetTimerData.time);
    
    return self.pickerData[component][row];
}

-(void)setTimer:(PresetTimer *)timer With:(UIPickerView *)pickerView{
    
    NSString *hour = [self.pickerHours objectAtIndex:[pickerView selectedRowInComponent:0]];
    NSString *min = [self.pickerMins objectAtIndex:[pickerView selectedRowInComponent:1]];
    NSString *sec = [self.pickerSecs objectAtIndex:[pickerView selectedRowInComponent:2]];
    NSString *hourMinSec = [hour stringByAppendingFormat:@":%@:%@", min, sec];
    
    timer.time = hourMinSec;
    
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {
    
//    if ([[PresetTimerData sharedModel].userPresetTimerData.time isEqualToString:@""]){
//        
//        [[PresetTimerData sharedModel].userPresetTimerData.time isEqualToString:@"00:00:00"];
//        
//        NSLog(@"Unsaved Timer: %@", [PresetTimerData sharedModel].userPresetTimerData.time);
//        
//        [self dismissViewControllerAnimated:YES completion:nil];
    
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
    }
    
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
