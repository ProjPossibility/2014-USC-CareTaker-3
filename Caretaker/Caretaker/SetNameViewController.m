//
//  SetNameViewController.m
//  Caretaker
//
//  Created by Laurence Wong on 3/13/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "SetNameViewController.h"

@interface SetNameViewController ()

@end

@implementation SetNameViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self initControlView];
    }
    return self;
}

- (id)initWithViewController:(ViewController*)inViewController
{
    self = [super init];
    if (self) {
        parentViewController = inViewController;
        [self initControlView];
    }
    return self;
}

- (void) finishedButtonAction
{
    if([nameField.text length])
    {
        parentViewController.myName = nameField.text;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"NOTICE" message:[NSString stringWithFormat:@"Please enter a valid name"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void) dismissKeyboard
{
    [nameField resignFirstResponder];
}

- (void) initControlView
{
    controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    [controlView setBackgroundColor:[UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    
    setName = [[UIButton alloc] initWithFrame:CGRectMake(10, 420, 300, 64)];
    [setName setBackgroundColor:[UIColor colorWithRed:0.729 green:0.243f blue:0.255f alpha:1.0f]];
    [setName setTitle:@"Finished" forState:UIControlStateNormal];
    [setName addTarget:self action:@selector(finishedButtonAction) forControlEvents:UIControlEventTouchUpInside];

    [controlView addSubview:setName];
    
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, 300, 64)];
    nameField.returnKeyType = UIReturnKeyDone;
    [nameField layer].borderColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f].CGColor;
    [nameField layer].borderWidth = 1.0f;
    nameField.delegate = self;
    
    [nameField setPlaceholder:@"Enter name"];
    [controlView addSubview:nameField];
    //[self.view addSubview:controlView];
    
    welcomeMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 300, 64)];
    [welcomeMessage setText:@"Welcome to Caretaker\nPlease enter your name"];
    [welcomeMessage setTextAlignment:NSTextAlignmentCenter];
    [welcomeMessage setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23.0]];
    welcomeMessage.numberOfLines = 0;
    [controlView addSubview:welcomeMessage];
    
    self.view = controlView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
