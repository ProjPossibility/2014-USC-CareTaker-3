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

- (void)goBackButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonAction:(id)sender
{
    self.reminder.mDate = self.datePicker.date;
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void) initControlView
{
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 140, 320, 216)];
    [self.controlView addSubview:self.datePicker];
    
    UILabel *enterDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 320, 70)];
    [enterDateLabel setText:@"Enter Date"];
    [self.controlView addSubview:enterDateLabel];
    
    [self.nextButton setTitle:@"Finish" forState:UIControlStateNormal];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    int a = 0;
    if(self.reminder.mName)
    {
        int b = 10;
    }
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
