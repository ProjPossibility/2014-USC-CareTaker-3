//
//  AppDelegate.h
//  Caretaker
//
//  Created by Francesca Nannizzi on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <PebbleKit/PebbleKit.h>
#import "AccelerationLogger.h"
#import "ClassificationController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    CMMotionManager *_motionManager;
    AccelerationLogger *accelLoggerPebble;
    ClassificationController *classificationController;
    ViewController *newViewController;
    
    BOOL onAlertCooldown;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (readonly) CMMotionManager *motionManager;


+ (NSString *) applicationDocumentsDirectory;
-(void) clearFiles;


@end
