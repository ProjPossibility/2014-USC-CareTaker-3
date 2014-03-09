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
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 140, 320, 216)];
    if(self.reminder.mDate)
    {
        self.datePicker.date = self.reminder.mDate;
    }
    [self.controlView addSubview:self.datePicker];
    
    UILabel *enterDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 70)];
    [enterDateLabel setText:@"Enter Date"];
    [self.controlView addSubview:enterDateLabel];
    
    [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
    
}

- (void)viewDidAppear:(BOOL)animated
{
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
