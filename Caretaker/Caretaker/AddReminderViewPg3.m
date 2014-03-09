//
//  AddReminderViewPg3.m
//  Caretaker
//
//  Created by Laurence Wong on 3/7/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "AddReminderViewPg3.h"

@interface AddReminderViewPg3 ()

@end

@implementation AddReminderViewPg3

- (id)init
{
    self = [super init];
    if (self) {
        [self initControlView];
    }
    return self;
}
- (id)initWithReminder:(Reminder *)reminder
{
    self = [super init];
    if(self) {
        self.reminder = reminder;
        [self initControlView];
        mRepeatFrequencyData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)goBackButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonAction:(id)sender
{
    self.reminder.mDate = self.datePicker.date;
    self.reminder.mRepeat = YES;
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popToViewController:self.rootView animated:YES];
}


- (void) initControlView
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 100, 320, 216)];
    if(self.reminder.mDate)
    {
        self.datePicker.date = self.reminder.mDate;
    }
    [self.controlView addSubview:self.datePicker];
    
    UILabel *enterDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 320, 70)];
    [enterDateLabel setText:@"Enter Date"];
    [self.controlView addSubview:enterDateLabel];
    
    [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
    
    self.mRepeatSelector = [[UITableView alloc] initWithFrame:CGRectMake(20, 310, 280, 135)];
    [self.mRepeatSelector setDelegate:self];
    [self.mRepeatSelector setDataSource:self];
    [self.mRepeatSelector setBounces:NO];
    [self.mRepeatSelector setSeparatorInset:UIEdgeInsetsZero];
    
    [self.controlView addSubview:self.mRepeatSelector];
    
}

- (void)viewDidAppear:(BOOL)animated
{
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//[[medicineReminder mReminders] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch([indexPath row])
    {
        default:
            return 45;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger labelIndex = [mRepeatFrequencyData indexOfObject:self.mCurrentSelectedRepeat];
    if (labelIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:labelIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.backgroundColor = [UIColor colorWithRed: 0.3f green:0.5f blue:1.0f alpha:1.0f];
        self.reminder.mRepeatFrequency = [Reminder getRepeatFrequencyFor:indexPath.row];
        self.mCurrentSelectedRepeat = [mRepeatFrequencyData objectAtIndex:indexPath.row];
        self.mCurrentSelectedRepeat.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
        UILabel *oldSelectedRepeat = [mRepeatFrequencyData objectAtIndex: oldIndexPath.row];
        oldSelectedRepeat.textColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"RepeatCell%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *repeatFrequencyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mRepeatSelector.frame.size.width,45)];
        switch(indexPath.row)
        {
            case 0:
                [repeatFrequencyLabel setText:@"None"];
                self.mCurrentSelectedRepeat = repeatFrequencyLabel;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.backgroundColor = [UIColor colorWithRed: 0.3f green:0.5f blue:1.0f alpha:1.0f];
                repeatFrequencyLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
                break;
            case 1:
                [repeatFrequencyLabel setText:@"Daily"];
                break;
            default:
                [repeatFrequencyLabel setText:@"Weekly"];
                break;
        }
        [repeatFrequencyLabel setTextAlignment:NSTextAlignmentCenter];
        [mRepeatFrequencyData addObject:repeatFrequencyLabel];
        [cell.contentView addSubview:repeatFrequencyLabel];
    }
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
