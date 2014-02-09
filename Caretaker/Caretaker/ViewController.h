//
//  ViewController.h
//  Caretaker
//
//  Created by Francesca Nannizzi on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicineReminder.h"
#import "AccelerationLogger.h"

@interface ViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    MedicineReminder *medicineReminder;
    UITableView *pendingReminders;
    AccelerationLogger *accelLoggerPhone;

}
@property (nonatomic) IBOutlet  UIView      *overlayView;
@property (nonatomic)           UIImagePickerController *imagePickerController;
@property (nonatomic, strong)   UIView      *controlView;
@property (nonatomic, strong)   UIButton    *choosePictureButton;
@property (nonatomic, strong)   UIButton    *showNotificationButton;
@property (nonatomic, strong)   UIButton    *showAreYouOkay;
@property (nonatomic, strong)   UITableView *pendingReminders;

-(void)setupControls;
-(void) startMotionDetect;


@end
