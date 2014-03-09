//
//  UpdateReminderViewPg3.m
//  Caretaker
//
//  Created by Laurence Wong on 3/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "UpdateReminderViewPg3.h"

@interface UpdateReminderViewPg3 ()

@end

@implementation UpdateReminderViewPg3

- (id) initWithReminder:(Reminder *)reminder
{
    self = [super initWithReminder:reminder];
    if(self) {
        [self initUpdateControlView];
    }
    return self;
}

- (void) finishedButtonAction:(id)sender
{
    [self.navigationController popToViewController:self.rootView animated:YES];
}

- (void) initUpdateControlView
{
    [self.goBackButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.nextButton addTarget:self action:@selector(finishedButtonAction:) forControlEvents:UIControlEventTouchUpInside];
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
