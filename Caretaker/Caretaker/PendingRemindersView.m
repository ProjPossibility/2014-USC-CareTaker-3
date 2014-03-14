//
//  PendingRemindersView.m
//  Caretaker
//
//  Created by Laurence Wong on 3/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "PendingRemindersView.h"
#import "MedicineReminder.h"
#import "NotificationManager.h"
#import "EditPendingReminderView.h"
#import "UpdateReminderViewPg1.h"

@interface PendingRemindersView ()

@end

@implementation PendingRemindersView

- (id)init
{
    self = [super init];
    if (self) {
        [self initTableViewAndButtons];
    }
    return self;
}

- (void)initTableViewAndButtons
{
    [self.view setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [controlView setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    [self.view addSubview:controlView];
    
    mPendingReminders = [[UITableView alloc] initWithFrame:CGRectMake(0, 100, 320, 410)];
    [mPendingReminders setDelegate:self];
    [mPendingReminders setDataSource:self];
    
    goBackButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 30, 310, 60)];
    [goBackButton setBackgroundColor:[UIColor colorWithRed:0.729 green:0.243f blue:0.255f alpha:1.0f]];
    [goBackButton addTarget:self action:@selector(goBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setTitle:@"Go Back" forState:UIControlStateNormal];
    [controlView addSubview:goBackButton];
    
    [controlView addSubview:mPendingReminders];
}

- (void) goBackButtonAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Reloading data");
    [mPendingReminders reloadData];
    if(mEditingReminder)
    {
        QuietLog(@"Updating reminder");
        [[MedicineReminder getInstance] addReminderWith:mEditingReminder];
        mEditingReminder = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectReminder:(id)sender
{
    UIButton *reminderViewButton = (UIButton *)sender;
    mEditingReminder = [[MedicineReminder getInstance].mReminders objectAtIndex:reminderViewButton.tag];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NOTICE" message:[NSString stringWithFormat:@"Do you want to edit or delete this reminder?"] delegate:self cancelButtonTitle:@"Edit" otherButtonTitles:@"Delete", nil];
    alertView.delegate = self;
    [alertView show];

}

- (void)editCurrentmEditingReminder
{
    if(mEditingReminder)
    {
    UpdateReminderViewPg1 *editReminderView = [[UpdateReminderViewPg1 alloc] initWithReminder:mEditingReminder];
     editReminderView.reminder = mEditingReminder;
     editReminderView.rootView = self;
     [self.navigationController pushViewController:editReminderView animated:YES];
    }
    else
    {
        QuietLog(@"Attempted edit on null mEditingReminder");
    }
}

- (void)deleteCurrentmEditingReminder
{
    if(mEditingReminder)
    {
        [[MedicineReminder getInstance] deleteReminder:mEditingReminder];
        QuietLog(@"Deleted reminder reference count = %ld", CFGetRetainCount((__bridge CFTypeRef)mEditingReminder));
        mEditingReminder = nil;
    }
    else
    {
        QuietLog(@"Attempted delete on null mEditingReminder");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    QuietLog(@"Clicked on reminder");
    switch(buttonIndex)
    {
        case 0:
            QuietLog(@"Clicked Edit");
            [self editCurrentmEditingReminder];
            break;
        case 1:
            QuietLog(@"Clicked Delete");
            [self deleteCurrentmEditingReminder];
            break;
        default:
            break;
    }
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
    int count = [[[MedicineReminder getInstance] mReminders] count];
    return count;
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
            return 64;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"OptionCell%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *reminderViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        Reminder *currentReminder = [[MedicineReminder getInstance].mReminders objectAtIndex:[indexPath row]];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 44)];
        nameLabel.text = currentReminder.mName;
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd HH:mm"];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 24, 320, 44)];
        dateLabel.text = [formatter stringFromDate:currentReminder.mDate];
        dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [reminderViewButton addSubview: nameLabel];
        [reminderViewButton addSubview: dateLabel];
        reminderViewButton.tag = [indexPath row];
        //need to make selectReminder take in a reminder
        [reminderViewButton addTarget:self action:@selector(selectReminder:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:reminderViewButton];
    }
    
    return cell;
}

@end
