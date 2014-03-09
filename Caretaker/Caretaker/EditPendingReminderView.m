//
//  EditPendingReminderView.m
//  Caretaker
//
//  Created by Laurence Wong on 3/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "EditPendingReminderView.h"

@interface EditPendingReminderView ()

@end

@implementation EditPendingReminderView

- (id)initWithReminder:(Reminder*)reminder
{
    self = [super init];
    if (self) {
        reminderToEdit = reminder;
        [self initInterface];
    }
    return self;
}

- (void)goBackButtonAction
{
    [self writeChangesToReminder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)writeChangesToReminder
{
    reminderToEdit.mName = nameField.text;
    reminderToEdit.mQuantity = quantityField.text;
    
}

- (void)initInterface
{
    [self.view setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    
    controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [controlView setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    [self.view addSubview:controlView];
    
    goBackButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 30, 320, 60)];
    [goBackButton setTitle:@"Go Back" forState:UIControlStateNormal];
    [goBackButton addTarget:self action:@selector(goBackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [goBackButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]];
    [controlView addSubview:goBackButton];
    
    nameField = [[UITextField alloc] initWithFrame: CGRectMake(0, 100, 320, 60)];
    nameField.text = reminderToEdit.mName;
    [controlView addSubview:nameField];
    
    quantityField = [[UITextField alloc] initWithFrame:CGRectMake(0, 170, 320, 60)];
    quantityField.text = reminderToEdit.mQuantity;
    [controlView addSubview:quantityField];
    
    
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
