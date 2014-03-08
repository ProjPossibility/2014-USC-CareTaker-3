//
//  AddReminderViewPg1.h
//  Caretaker
//
//  Created by Laurence Wong on 3/6/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCWIDTH [[UIScreen mainScreen] bounds].size.width
#define SCHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface BaseAddReminderView : UIViewController <UITextFieldDelegate>
{
}

@property (nonatomic, strong) UIView* controlView;

-(void) goBackButtonAction:(id)sender;
-(void) nextButtonAction:(id)sender;


@end
