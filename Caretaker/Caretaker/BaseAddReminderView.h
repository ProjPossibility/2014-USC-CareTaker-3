//
//  AddReminderViewPg1.h
//  Caretaker
//
//  Created by Laurence Wong on 3/6/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

#define SCWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface BaseAddReminderView : UIViewController <UITextFieldDelegate>
{
}

@property (nonatomic, strong) UIView* controlView;
@property (nonatomic, strong) Reminder* reminder;
@property (nonatomic, strong) UIButton *goBackButton;
@property (nonatomic, strong) UIButton *nextButton;

-(void) goBackButtonAction:(id)sender;
-(void) nextButtonAction:(id)sender;
- (id)initWithReminder:(Reminder *)reminder;
@end
