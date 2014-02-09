//
//  MedicineReminder.m
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "MedicineReminder.h"
#import "Reminder.h"

@implementation MedicineReminder

- (id)init
{
    self = [super init];
    if (self) {
        mReminders = [[NSMutableArray alloc] init];
        mTimers = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)showReminder:(id)sender
{
    Reminder *reminder = (Reminder *)[sender userInfo];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" message:[NSString stringWithFormat:@"%@\n%d", reminder.mName, reminder.mQuantity] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    [alertView setValue:reminder.mPicture forKey:@"accessoryView"];
    
    [alertView addSubview:reminder.mPicture];
    
    [alertView show];
    
    if(!reminder.mRepeat)
    {
        [mReminders removeObject: reminder];
    }
}

-(void)timerEvent
{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"AHHHHHHHH A NOTIFICATION!";
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.hasAction = NO;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self];

}
-(void)addReminderWith:(NSString *)name and:(int)quantity and:(NSDate *)date and:(BOOL)repeat and:(UIImageView *)imageView
{
    Reminder *newReminder = [[Reminder alloc] init];
    newReminder.mName = name;
    newReminder.mQuantity = quantity;
    newReminder.mDate = date;
    newReminder.mRepeat = repeat;
    newReminder.mPicture = imageView;
    
    [mReminders addObject:newReminder];
    NSTimer *newTimer = [NSTimer timerWithTimeInterval:10.0f target:self selector:@selector(showReminder:) userInfo:newReminder repeats:YES];
    [mTimers addObject:newTimer];
    
}
@end
