//
//  SetTimerViewController.m
//  Time
//
//  Created by Justine Gartner on 8/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

#import "SetTimerViewController.h"

@interface SetTimerViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userInputTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *setTimerPickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic) NSArray *pickerData;

@end

@implementation SetTimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.pickerData = @[@[ @(00), @(01), @(02), @(03), @(04), @(05)],
//                        @[ @(00), @(01), @(02), @(03), @(04), @(05)],
//                        @[ @(00), @(01), @(02), @(03), @(04), @(05)]
//                        ];
    self.pickerData = @[@[ @"00", @"01", @"02", @"03", @"04", @"05"],
                        @[ @"00", @"01", @"02", @"03", @"04", @"05"],
                        @[ @"00", @"01", @"02", @"03", @"04", @"05"]
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
    
    return self.pickerData[component][row];
}

- (IBAction)cancelButtonTapped:(UIBarButtonItem *)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doneButtonTapped:(UIBarButtonItem *)sender {
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
