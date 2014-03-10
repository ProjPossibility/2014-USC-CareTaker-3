//
//  AreYouOkayManager.m
//  Caretaker
//
//  Created by Laurence Wong on 3/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "AreYouOkayManager.h"
#import "NotificationManager.h"

@implementation AreYouOkayManager

+ (AreYouOkayManager*) getInstance
{
    static AreYouOkayManager *instance;
    
    if(!instance)
    {
        instance = [[AreYouOkayManager alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        PHONE_ALERT_COOLDOWN = [NSNumber numberWithFloat:1.5];
    }
    return self;
}

-(void) scheduleAreYouOkayAfter:(NSTimeInterval)after
{
    if(!hasAreYouOkayBeenScheduled)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WARNING" message:[NSString stringWithFormat:@"Are you okay?"] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
        alertView.delegate = self;
        [alertView show];
        NSTimer *areYouOkayTimer = [NSTimer timerWithTimeInterval:[PHONE_ALERT_COOLDOWN floatValue] target:self selector:@selector(increaseAreYouOkayAlert) userInfo:Nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:areYouOkayTimer forMode:NSRunLoopCommonModes];
        
        hasAreYouOkayBeenScheduled = YES;
    }
}

-(void) increaseAreYouOkayAlert
{
    
}

-(void) resetPendingNotificationLock
{
    hasAreYouOkayBeenScheduled = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            QuietLog(@"Clicked YES");
            [self resetPendingNotificationLock];
            break;
        case 1:
            QuietLog(@"Clicked NO");
            [self resetPendingNotificationLock];
            break;
        default:
            break;
    }
}

@end
