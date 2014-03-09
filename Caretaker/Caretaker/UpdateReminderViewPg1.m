//
//  UpdateReminderViewPg1.m
//  Caretaker
//
//  Created by Laurence Wong on 3/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "UpdateReminderViewPg1.h"
#import "UpdateReminderViewPg2.h"
#import "MedicineReminder.h"

@interface UpdateReminderViewPg1 ()

@end

@implementation UpdateReminderViewPg1

- (id) initWithReminder:(Reminder *)reminder
{
    self = [super initWithReminder:reminder];
    if(self) {
        [self initUpdateControlView];
    }
    return self;
}

- (void)nextButtonAction:(id)sender
{
    self.reminder.mName = self.nameInput.text;
    self.reminder.mQuantity = self.quantityInput.text;
    UpdateReminderViewPg2 *newView = [[UpdateReminderViewPg2 alloc] initWithReminder:self.reminder];
    newView.rootView = self.rootView;
    [self.navigationController pushViewController:newView animated:YES];
}

- (void) goBackButtonAction:(id)sender
{
    [self.navigationController popToViewController:self.rootView animated:YES];
}


- (void) finishedButtonAction
{
    self.reminder.mName = self.nameInput.text;
    self.reminder.mQuantity = self.quantityInput.text;
    [self.navigationController popToViewController:self.rootView animated:YES];
}

- (void) initUpdateControlView
{
    [self.goBackButton setTitle:@"Cancel" forState:UIControlStateNormal];
    
    finishedButton = [[UIButton alloc] initWithFrame:CGRectMake(5, self.nextButton.frame.origin.y - 70, self.nextButton.frame.size.width, self.nextButton.frame.size.height)];
    [finishedButton setTitle:@"Finish" forState:UIControlStateNormal];
    [finishedButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]];
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
