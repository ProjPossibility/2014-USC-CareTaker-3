//
//  MedicineReminder.m
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "MedicineReminder.h"
#import "NotificationManager.h"


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
        
        [self addTempReminders];
    }
    return self;
}

- (Reminder *)getNewReminder
{
    Reminder *newReminder = [[Reminder alloc] init];
    newReminder.mID = [self.mReminders count];
    [self.mReminders addObject:newReminder];
    return newReminder;
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
        NSTimeInterval intervalUntilFire = 60.0f;
        reminder.mTimer = [NSTimer timerWithTimeInterval:intervalUntilFire target:self selector:@selector(showReminder:) userInfo:reminder repeats:NO];
        reminder.mDate = [NSDate dateWithTimeInterval:intervalUntilFire sinceDate:[NSDate date]];
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

#pragma - message ("Adding temp reminders so that I don't have to keep doing it")
-(void)addTempReminders
{
    Reminder *newReminder = [[Reminder alloc] init];
    newReminder.mName = @"Stuff";
    newReminder.mQuantity = @"Twenty";
    newReminder.mDate = [NSDate dateWithTimeIntervalSinceNow:4000];
    
    Reminder *newReminder1 = [[Reminder alloc] init];
    newReminder1.mName = @"OtherStuff";
    newReminder1.mQuantity = @"1";
    newReminder1.mDate = [NSDate dateWithTimeIntervalSinceNow:400];
    
    [self addReminderWith:newReminder];
    [self addReminderWith:newReminder1];
}

-(void)addReminderWith:(Reminder*)thisReminder
{
    UIBackgroundTaskIdentifier bgTask =0;
    UIApplication  *app = [UIApplication sharedApplication];
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        [app endBackgroundTask:bgTask];
    }];
    
    if(![self.mReminders containsObject:thisReminder])
    {
        NSLog(@"New Reminder");
        [self.mReminders addObject:thisReminder];
        
        NSTimeInterval blah = [thisReminder.mDate timeIntervalSinceDate:[NSDate date]];
        NSTimer *newTimer = [NSTimer timerWithTimeInterval:blah target:self selector:@selector(showReminder:) userInfo:thisReminder repeats:NO];
        thisReminder.mTimer = newTimer;
        [[NSRunLoop currentRunLoop] addTimer:thisReminder.mTimer forMode:NSRunLoopCommonModes];
    }
    else
    {
        NSLog(@"Found reminder");
        [thisReminder.mTimer invalidate];
        NSTimeInterval blah = [thisReminder.mDate timeIntervalSinceDate:[NSDate date]];
        thisReminder.mTimer = [NSTimer timerWithTimeInterval:blah target:self selector:@selector(showReminder:) userInfo:thisReminder repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:thisReminder.mTimer forMode:NSRunLoopCommonModes];
    }
    
}
@end
