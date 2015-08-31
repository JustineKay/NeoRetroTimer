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

@property (strong, nonatomic) IBOutlet UIView *backgroundView;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *hrsMinsSecsLabels;

@end

@implementation SetTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundView.backgroundColor = [PresetTimerData sharedModel].ghostGrey;
    self.userInputTextField.font = [UIFont fontWithName:@"PrintBold" size:18.0];
    
    [self setupLabelUI];
    
    self.userInputTextField.text = @"";
    
    self.pickerHours = [self setDigitsForPickerColumnArrays];
    self.pickerMins = [self setDigitsForPickerColumnArrays];
    self.pickerSecs = [self setDigitsForPickerColumnArrays];
    
    self.pickerData = @[self.pickerHours,
                        self.pickerMins,
                        self.pickerSecs
                        ];
    
    self.setTimerPickerView.dataSource = self;
    self.setTimerPickerView.delegate = self;
}

- (void)setupLabelUI {
    NSArray *labels = self.hrsMinsSecsLabels;
    
        for (UILabel *label in labels) {
            label.font = [UIFont fontWithName:@"PrintBold" size:22.0];
            label.textColor = [PresetTimerData sharedModel].burntOrange;
            label.layer.borderWidth = 1.5;
            label.layer.borderColor = [PresetTimerData sharedModel].chartreuse.CGColor;
            //label.layer.backgroundColor = [PresetTimerData sharedModel].chartreuse.CGColor;
            label.layer.cornerRadius = 5.0;
        }
}

-(NSMutableArray *)setDigitsForPickerColumnArrays {
    
    NSMutableArray *digits = @[@"00"].mutableCopy;
    
    NSInteger integer = 0;
    
    for (int i = 0; i < 99; i++) {
        
        integer += 1;
        
        NSString *digit = [NSString stringWithFormat:@"%ld", integer];
        
        if ([digit integerValue] < 10) {
            
            NSString *zero = @"0";
            
            digit = [zero stringByAppendingString:digit];
        };
        
        [digits addObject:digit];
        
    }
    
    return digits;

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 3;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [self.pickerData[component] count];
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return self.pickerData[component][row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
        [pickerLabel setFont:[UIFont fontWithName:@"DigitaldreamFat" size:22.0]];
        
        [pickerLabel setTextColor:[PresetTimerData sharedModel].eggplant];
        
    }
    //picker view array is the datasource
    
    [pickerLabel setText:[self.pickerHours objectAtIndex:row]];
    [pickerLabel setText:[self.pickerMins objectAtIndex:row]];
    [pickerLabel setText:[self.pickerSecs objectAtIndex: row]];
    
    return pickerLabel;
    
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

@end
