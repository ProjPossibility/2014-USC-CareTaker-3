//
//  ViewController.h
//  Caretaker
//
//  Created by Francesca Nannizzi on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MedicineReminder.h"
#import "AccelerationLogger.h"
#import "Reminder.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate,
    ABPeoplePickerNavigationControllerDelegate,
    UIAlertViewDelegate>
{
    AccelerationLogger *accelLoggerPhone;

    int areYouOkayLackOfResponse;
    NSTimer *areYouOkayTimer;
    
    NSString *emergencyNumber;
    Reminder *newReminder;
    
    BOOL onAlertCooldown;
    
    ABRecordRef currentPotentialContact;
}

@property (nonatomic) IBOutlet  UIView      *overlayView;
@property (nonatomic)           UIImagePickerController *imagePickerController;
@property (nonatomic, strong)   UIView      *controlView;
@property (nonatomic, strong)   UIButton    *choosePictureButton;
@property (nonatomic, strong)   UIButton    *showPendingRemindersButton;
@property (nonatomic, strong)   UIButton    *showNotificationButton;
@property (nonatomic, strong)   UIButton    *showAreYouOkay;
@property (nonatomic, strong)   UIButton    *sendTextMessageButton;
@property (nonatomic, strong)   UIButton    *setContactButton;
@property (nonatomic, strong)   NSString    *myName;

@property (nonatomic, strong)   UILabel    *contactNameLabel;
@property (nonatomic, strong)   UILabel    *contactPhoneLabel;

-(void) setupControls;
-(void) startMotionDetect;
-(void) showAreYouOkay:(id)sender;
-(void) writeDataToFile;


@end
