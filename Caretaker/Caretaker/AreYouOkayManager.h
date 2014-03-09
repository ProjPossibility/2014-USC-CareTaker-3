//
//  AreYouOkayManager.h
//  Caretaker
//
//  Created by Laurence Wong on 3/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreYouOkayManager : NSObject
{
    NSNumber *PHONE_ALERT_COOLDOWN;
    BOOL hasAreYouOkayBeenScheduled;
}

+ (AreYouOkayManager*) getInstance;
-(void) scheduleAreYouOkayAfter:(NSTimeInterval)after;
-(void) resetPendingNotificationLock;

@end
