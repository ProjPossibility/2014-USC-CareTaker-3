//
//  AddReminderViewPg1.m
//  Caretaker
//
//  Created by Laurence Wong on 3/7/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "AddReminderViewPg1.h"
#import "AddReminderViewPg2.h"

@interface AddReminderViewPg1 ()

@end

@implementation AddReminderViewPg1

- (id)init
{
    self = [super init];
    if (self) {
        [self initControlView];
    }
    return self;
}

- (void) dismissKeyboard
{
    [self.nameInput resignFirstResponder];
    [self.quantityInput resignFirstResponder];
}

- (void) initControlView
{
    self.nameInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 80, SCWIDTH - 10, 120)];
    [self.nameInput setPlaceholder:@"Name of medication"];
    [self.nameInput setBorderStyle:UITextBorderStyleLine];
    [self.nameInput layer].borderWidth = 2;
    self.nameInput.delegate = self;
    self.nameInput.returnKeyType = UIReturnKeyDone;
    [self.nameInput setFont:[UIFont systemFontOfSize:35]];
    [self.controlView addSubview:self.nameInput];
    
    self.quantityInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 210, SCWIDTH - 10, 120)];
    [self.quantityInput setPlaceholder:@"Amount of medication"];
    [self.quantityInput setBorderStyle:UITextBorderStyleLine];
    [self.quantityInput layer].borderWidth = 2;
    self.quantityInput.delegate = self;
    self.quantityInput.keyboardType = UIKeyboardTypeDecimalPad;
    self.quantityInput.returnKeyType = UIReturnKeyDone;
    [self.quantityInput setFont:[UIFont systemFontOfSize:35]];
    [self.controlView addSubview:self.quantityInput];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
}

- (void)goBackButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonAction:(id)sender
{
    AddReminderViewPg2 *newView = [[AddReminderViewPg2 alloc] init];
    [self.navigationController pushViewController:newView animated:YES];
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
