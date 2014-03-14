//
//  SetNameViewController.h
//  Caretaker
//
//  Created by Laurence Wong on 3/13/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "ViewController.h"

@interface SetNameViewController : UIViewController <UITextFieldDelegate>
{
    UIView* controlView;
    
    UIButton* setName;
    UITextField* nameField;
    
    ViewController* parentViewController;
}

-(id)initWithViewController:(ViewController*)inViewController;

@end
