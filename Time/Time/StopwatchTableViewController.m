//
//  StopwatchTableViewController.m
//  Time
//
//  Created by Justine Gartner on 8/22/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

//add NSDateFormatter to LapTimeLabel up top and then add to as a NSString to the lap list at the bottom


#import "StopwatchTableViewController.h"

@interface StopwatchTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *lapTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *startPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *lapButton;

@property (nonatomic) NSTimer *timer;
@property (nonatomic) BOOL isRunning;
@property (nonatomic) NSInteger millisecondsElapsed;
@property (nonatomic) NSInteger lapMilliElapsed;

@property (nonatomic) NSDate *startTime;
@property (nonatomic) NSDate *finishTime;
@property (nonatomic) NSTimeInterval currentTime;

@property (nonatomic) NSMutableArray *laps;
@property (nonatomic) NSDate *currentLapStartTime;
@property (nonatomic) NSTimeInterval currentLapTime;
@property (nonatomic) NSMutableArray *lapTimes;
@property (strong, nonatomic) IBOutlet UITableView *lapTableView;

- (void)updateLapTimer;

@end


@implementation StopwatchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isRunning = NO;
    
    _currentTime = 0;
    _currentLapTime = 0;
    _laps = [NSMutableArray array];
    _isRunning = NO;
    _currentLapStartTime = 0;
    _startTime = nil;
    _finishTime = nil;
   
}


- (void)dealloc
{
    self.currentTime = 0;
    self.currentLapTime = 0;
    self.laps = [NSMutableArray array];
    self.isRunning = NO;
    self.startTime = nil;
    self.finishTime = nil;
}



- (IBAction)resetButtonTapped:(UIButton *)sender {

    self.currentTime = 0;
    [self.laps removeAllObjects];
    self.isRunning = NO;
    self.startTime = nil;
    self.finishTime = nil;
    
    self.timeLabel.text = @"00.00.00";
   self.lapTimeLabel.text = @"00.00.00";
    

    [self.lapTableView reloadData];
   
    }


- (IBAction)startPauseButtonTapped:(UIButton *)sender {
    if (self.currentLapStartTime == nil) {
        self.currentLapStartTime = [NSDate date];
    }

    
    if (!self.isRunning) {
        self.isRunning = YES;
        self.startTime = [NSDate date];
        
        if (![self.timer isValid]) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                          target:self
                                                        selector:@selector(updateTimer)
                                                        userInfo:nil
                                                         repeats:YES];
            
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            
             [self.startPauseButton setImage:[UIImage imageNamed:@"pauseIcon.png"] forState:UIControlStateNormal];
        }
      
    } else {
        self.isRunning = NO;
        self.finishTime = [NSDate date];
        
        [self.timer invalidate];
        
        [self.startPauseButton setImage:[UIImage imageNamed:@"playIcon.png"] forState:UIControlStateNormal];
    }
}



- (IBAction)lapButtonTapped:(UIButton *)sender {
    
      NSLog(@"Current time: %02f", self.currentLapTime);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"mm : ss : SS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSDate * newNow = [NSDate dateWithTimeIntervalSinceReferenceDate:self.currentLapTime];
    NSString *timeString = [dateFormatter stringFromDate:newNow];
    self.lapTimeLabel.text = timeString;
    
     [self.laps addObject:self.lapTimeLabel.text];

    self.currentLapStartTime = [NSDate date];
    
    [self.lapTableView reloadData];
}



- (void)updateTimer {
    self.millisecondsElapsed += 1;
    
    NSInteger minutes = self.millisecondsElapsed / 6000;
    NSInteger remainder_m = self.millisecondsElapsed % 6000; //remaining milliseconds
    
    
    NSInteger seconds =   remainder_m/100 ; // seconds
    NSInteger remainder_s = remainder_m % 100; //remaining seconds
    
    NSInteger millisec = remainder_s;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)minutes, (long)seconds, (long)millisec];
}



- (void)updateLapTimer {
    self.lapMilliElapsed += 1;
    
    NSInteger minutes = self.lapMilliElapsed / 6000;
    NSInteger remainder_m = self.lapMilliElapsed % 6000; //remaining milliseconds
    
    
    NSInteger seconds =   remainder_m/100 ; // seconds
    NSInteger remainder_s = remainder_m % 100; //remaining seconds
    
    NSInteger millisec = remainder_s;
    
    self.lapTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)minutes, (long)seconds, (long)millisec];
}



#pragma mark - Current Time

- (NSTimeInterval)currentTime {
    if (self.isRunning) {
        return [[NSDate date] timeIntervalSinceDate:self.startTime];
    }
    
    return [self.finishTime timeIntervalSinceDate:self.startTime];
}

- (NSTimeInterval)currentLapTime {
    if (self.isRunning) {
        NSLog(@"%f", [[NSDate date] timeIntervalSinceDate:self.currentLapStartTime]);
        return [[NSDate date] timeIntervalSinceDate:self.currentLapStartTime];
    }
    
    return 0;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.laps count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lapViewCell" forIndexPath:indexPath];
    
    unsigned long lapNumber = indexPath.row + 1;

   NSString *key = [self.laps objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"Lap %lu", lapNumber];
    
    cell.detailTextLabel.text = key;
    
   return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
