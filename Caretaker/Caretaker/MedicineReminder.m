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
        self.mReminders = [[NSMutableArray alloc] init];
        self.mImages = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)showReminder:(id)sender
{
    Reminder *reminder = (Reminder *)[sender userInfo];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" message:[NSString stringWithFormat:@"Don't forget to take:\n%d %@(s)", reminder.mQuantity, reminder.mName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertView.delegate = self;
    alertView.frame = CGRectMake(0, 0, 320, 480);
    reminder.mImage.frame = CGRectMake(0, 0, 240, 180);
    [alertView setValue:reminder.mImage forKey:@"accessoryView"];
    [alertView show];
    
    if(!reminder.mRepeat)
    {
        [self.mReminders removeObject: reminder];
    }
    else
    {
        //86400 seconds in day
        reminder.mTimer = [NSTimer timerWithTimeInterval:60.0f target:self selector:@selector(showReminder:) userInfo:reminder repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:reminder.mTimer forMode:NSRunLoopCommonModes];
    }
}

-(void) alertView: ( UIAlertView *) alertView clickedButtonAtIndex: ( NSInteger ) buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            break;
        default:
            NSLog(@"THIS SHOUL NEVER EVER EVER HAPPEN");
            break;
    }
}

-(void)addReminderWith:(NSString *)name and:(int)quantity and:(NSDate *)date and:(BOOL)repeat and:(NSString *)imageUid
{
    Reminder *newReminder = [[Reminder alloc] init];
    newReminder.mName = name;
    newReminder.mQuantity = quantity;
    newReminder.mDate = date;
    newReminder.mRepeat = repeat;
    newReminder.mImage = [self.mImages objectForKey:imageUid];
    
    
    UIBackgroundTaskIdentifier bgTask =0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    [self.mReminders addObject:newReminder];
    NSTimeInterval blah = [newReminder.mDate timeIntervalSinceDate:[NSDate date]];
    NSTimer *newTimer = [NSTimer timerWithTimeInterval:blah target:self selector:@selector(showReminder:) userInfo:newReminder repeats:NO];
    newReminder.mTimer = newTimer;
    [[NSRunLoop currentRunLoop] addTimer:newReminder.mTimer forMode:NSRunLoopCommonModes];
    //[self showReminder:newReminder];
    
}
@end
