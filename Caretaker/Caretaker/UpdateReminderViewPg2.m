//
//  UpdateReminderViewPg2.m
//  Caretaker
//
//  Created by Laurence Wong on 3/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "UpdateReminderViewPg2.h"
#import "UpdateReminderViewPg3.h"

@interface UpdateReminderViewPg2 ()

@end

@implementation UpdateReminderViewPg2

- (id) initWithReminder:(Reminder *)reminder
{
    self = [super initWithReminder:reminder];
    if(self) {
        [self initUpdateControlView];
    }
    return self;
}

- (void) finishedButtonAction
{
    [self.navigationController popToViewController:self.rootView animated:YES];
}
- (void) goBackButtonAction:(id)sender
{
    [self.navigationController popToViewController:self.rootView animated:YES];
}

- (void)nextButtonAction:(id)sender
{
    UpdateReminderViewPg3 *newView = [[UpdateReminderViewPg3 alloc] initWithReminder:self.reminder];
    newView.rootView = self.rootView;
    [self.navigationController pushViewController:newView animated:YES];
}

- (void) initUpdateControlView
{
    [self.goBackButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    finishedButton = [[UIButton alloc] initWithFrame:CGRectMake(5, self.nextButton.frame.origin.y - 70, self.nextButton.frame.size.width, self.nextButton.frame.size.height)];
    [finishedButton setTitle:@"Finish" forState:UIControlStateNormal];
    [finishedButton setBackgroundColor:careTakerRed];
    [finishedButton addTarget:self action:@selector(finishedButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.controlView addSubview:finishedButton];
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
