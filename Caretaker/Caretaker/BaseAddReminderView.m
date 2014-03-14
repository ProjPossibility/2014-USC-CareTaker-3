//
//  AddReminderViewPg1.m
//  Caretaker
//
//  Created by Laurence Wong on 3/6/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "BaseAddReminderView.h"



@interface BaseAddReminderView ()

@end

@implementation BaseAddReminderView



- (id)initWithControlView:(UIView*)inControlView
{
    self = [super init];
    if (self) {
        careTakerRed = [UIColor colorWithRed:0.729 green:0.243f blue:0.255f alpha:1.0f];
        [self.view setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        self.view = inControlView;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        careTakerRed = [UIColor colorWithRed:0.729 green:0.243f blue:0.255f alpha:1.0f];
        [self.view setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        self.controlView = [self initializeControlViewFor:self];
    }
    return self;
}

-(id)initWithReminder:(Reminder *)reminder
{
    careTakerRed = [UIColor colorWithRed:0.729 green:0.243f blue:0.255f alpha:1.0f];

    return self;
}

- (void)goBackButtonAction:(id)sender
{
}

-(void) nextButtonAction:(id)sender
{
}

- (UIScrollView *)initializeControlViewFor:(BaseAddReminderView *)reminderView
{
    UIView *newControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCWIDTH, SCHEIGHT)];
    [reminderView.view addSubview:newControlView];
    
    self.goBackButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, SCWIDTH - 10, 60)];
    [self.goBackButton setTitle:@"Go Back" forState:UIControlStateNormal];
    [self.goBackButton setBackgroundColor:careTakerRed];
    [self.goBackButton addTarget:reminderView action:@selector(goBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [newControlView addSubview:self.goBackButton];
    
    self.nextButton = [[UIButton alloc] initWithFrame:CGRectMake(5, SCHEIGHT - 110, SCWIDTH - 10, 60)];
    [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [self.nextButton setBackgroundColor:careTakerRed];
    [self.nextButton addTarget:reminderView action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [newControlView addSubview:self.nextButton];
    UIScrollView *newUIScrollView = [[UIScrollView alloc] initWithFrame:[newControlView frame]];
    [newUIScrollView addSubview:newControlView];
    return newUIScrollView;
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

#pragma mark - Text Field Stuff

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
