//
//  MedicineReminder.m
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "MedicineReminder.h"


@implementation MedicineReminder


+ (MedicineReminder*) getInstance
{
    static MedicineReminder *instance;
    
    if(!instance)
    {
        instance = [[MedicineReminder alloc] init];
    }
    
    return instance;
}

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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" message:[NSString stringWithFormat:@"Don't forget to take:\n%@ %@(s)", reminder.mQuantity, reminder.mName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    alertView.delegate = self;
    alertView.frame = CGRectMake(0, 0, 320, 480);
    reminder.mImage.frame = CGRectMake(0, 0, 240, 180);
    [alertView setValue:[self.mImages objectForKey:reminder.mImageUid] forKey:@"accessoryView"];
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

-(void)addReminderWith:(Reminder*)thisReminder
{
    UIBackgroundTaskIdentifier bgTask =0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    [self.mReminders addObject:thisReminder];
    NSTimeInterval blah = [thisReminder.mDate timeIntervalSinceDate:[NSDate date]];
    NSTimer *newTimer = [NSTimer timerWithTimeInterval:blah target:self selector:@selector(showReminder:) userInfo:thisReminder repeats:NO];
    thisReminder.mTimer = newTimer;
    [[NSRunLoop currentRunLoop] addTimer:thisReminder.mTimer forMode:NSRunLoopCommonModes];
    //[self showReminder:newReminder];
    
}
@end
