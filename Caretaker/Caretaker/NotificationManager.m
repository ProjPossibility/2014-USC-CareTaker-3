//
//  NotificationManager.m
//  Caretaker
//
//  Created by Keith DeRuiter on 3/1/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "NotificationManager.h"

@interface NotificationManager ()

-(void) cooldownOver;

@end


@implementation NotificationManager

-(void) cooldownOver
{
    self.onAlertCooldown = NO;
}

- (void)scheduleNewLocalNotification:(NSString*)notificationMsg After:(NSTimeInterval)seconds
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    localNotif.alertBody = notificationMsg;
    localNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow:seconds];
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

@end
