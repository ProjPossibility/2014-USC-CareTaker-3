//
//  EditPendingReminderView.h
//  Caretaker
//
//  Created by Laurence Wong on 3/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reminder.h"

@interface EditPendingReminderView : UIViewController
{
    UIView *controlView;
    UIButton *goBackButton;
    UITextField *nameField;
    UITextField *quantityField;
    UIButton *selectImageButton;
    Reminder *reminderToEdit;
}

-(id)initWithReminder:(Reminder*)reminder;

@end
