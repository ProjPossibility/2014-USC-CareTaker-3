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

- (void)scheduleNewLocalNotification:(NSString*)notificationMsg After:(NSTimeInterval)seconds;
+ (NotificationManager*) getInstance;

@end
