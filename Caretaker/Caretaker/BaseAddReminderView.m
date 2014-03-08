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
        [self.view setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        self.view = inControlView;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.view setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
        self.controlView = [self initializeControlViewFor:self];
    }
    return self;
}

- (void)goBackButtonAction:(id)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void) nextButtonAction:(id)sender
{
    /*
    AddReminderViewPg1 *newReminderView = [[AddReminderViewPg1 alloc] init];
    newReminderView.controlView = [self initializeControlViewFor:newReminderView];
    
    [self.navigationController pushViewController:newReminderView animated:YES];
     */
}

- (UIView *)initializeControlViewFor:(BaseAddReminderView *)reminderView
{
    UIView *newControlView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SCWIDTH, SCHEIGHT - 70)];
    [reminderView.view addSubview:newControlView];
    
    UIButton *goBackButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, SCWIDTH - 10, 60)];
    [goBackButton setTitle:@"Go Back" forState:UIControlStateNormal];
    [goBackButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]];
    [goBackButton addTarget:reminderView action:@selector(goBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [newControlView addSubview:goBackButton];
    
    UIButton *nextButton = [[UIButton alloc] initWithFrame:CGRectMake(5, SCHEIGHT - 150, SCWIDTH - 10, 60)];
    [nextButton setTitle:@"Next" forState:UIControlStateNormal];
    [nextButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]];
    [nextButton addTarget:reminderView action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [newControlView addSubview:nextButton];
    return newControlView;
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
