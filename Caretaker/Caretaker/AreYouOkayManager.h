//
//  AreYouOkayManager.h
//  Caretaker
//
//  Created by Laurence Wong on 3/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreYouOkayManager : NSObject <UIAlertViewDelegate>
{
    int mCurrentAlertLevel;
    NSNumber *PHONE_ALERT_COOLDOWN;
    NSTimer* areYouOkayTimer;
    NSTimer* vibrateTimer;
    UIAlertView *currentAlertView;
    BOOL hasAreYouOkayBeenScheduled;
    NSURLConnection *currentConnection;

}

+ (AreYouOkayManager*) getInstance;
-(void) scheduleAreYouOkayAfter:(NSTimeInterval)after;
-(void) resetPendingNotificationLock;
-(void) sendTextMessageToNumber;

@property (nonatomic) NSString *emergencyContactName;
@property (nonatomic) NSString *emergencyContactPhone;

@property (nonatomic) NSString *myName;

@end
