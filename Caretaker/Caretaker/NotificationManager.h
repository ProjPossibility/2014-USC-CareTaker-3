//
//  NotificationManager.h
//  Caretaker
//
//  Created by Keith DeRuiter on 3/1/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject
{
    NotificationManager *instance;
}

- (UILocalNotification *)scheduleNewLocalNotification:(NSString *)notificationTitle WithMsg:(NSString*)notificationMsg After:(NSTimeInterval)seconds;
- (UILocalNotification *)updateLocalNotification:(UILocalNotification *)localNotification WithTitle:(NSString *)notificationTitle WithMsg:(NSString*)notificationMsg After:(NSTimeInterval)seconds;
+ (NotificationManager*) getInstance;

@end
