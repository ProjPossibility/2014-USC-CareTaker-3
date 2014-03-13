//
//  MedicineReminder.m
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "MedicineReminder.h"
#import "NotificationManager.h"
#import <AssetsLibrary/AssetsLibrary.h>


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
        [self readRemindersFromDatabase];
        //[self addTempReminders];
    }
    return self;
}

- (void)dumpRemindersToDatabase
{
    for(Reminder *reminderItr in self.mReminders)
    {
        [self writeReminderToDatabase:reminderItr];
    }
    QuietLog(@"Wrote out all reminders");
}

- (void)writeReminderToDatabase:(Reminder *)reminder
{
    NSManagedObject *managedReminderObject = [NSEntityDescription
                                              insertNewObjectForEntityForName:@"Reminder"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [managedReminderObject setValue:reminder.mName forKey:@"mName"];
    [managedReminderObject setValue:reminder.mQuantity forKey:@"mQuantity"];
    [managedReminderObject setValue:reminder.mDate forKey:@"mDate"];
    NSString *reminderImageUrl = [NSString stringWithFormat:@"%@", reminder.mImageUid];
    [managedReminderObject setValue:reminderImageUrl forKey:@"mImageUid"];
    NSNumber *repeatFrequencyIndex = [NSNumber numberWithInt:[Reminder getIndexForRepeatFrequency:reminder.mRepeatFrequency]];
    [managedReminderObject setValue:repeatFrequencyIndex forKey:@"mRepeatFrequency"];
    //[managedReminderObject setValue:reminder.mNotification forKey:@"mNotification"];
    
    QuietLog(@"imageURL: %@", reminder.mImageUid);
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error saving reminder: %@", [error localizedDescription]);
    }
}

- (void)readRemindersFromDatabase
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Reminder" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        Reminder *newReminder = [[Reminder alloc] init];
        newReminder.mName = [info valueForKey:@"mName"];
        newReminder.mQuantity = [info valueForKey:@"mQuantity"];
        newReminder.mImageUid = [info valueForKey:@"mImageUid"];
        newReminder.mDate = [info valueForKey:@"mDate"];
        NSNumber *reminderRepeatFrequency = [info valueForKey:@"mRepeatFrequency"];
        newReminder.mRepeatFrequency = [Reminder getRepeatFrequencyFor:[reminderRepeatFrequency integerValue]];
        //newReminder.mNotification = [info valueForKey:@"mNotificaton"];
        [self fetchUIImageFromAssetLibraryForURL:newReminder.mImageUid];
        //need to do date checking to see which reminders need to be updated
        
        
        [self addReminderWith:newReminder];
    }
    QuietLog(@"Read in all reminders");
}

- (void)fetchUIImageFromAssetLibraryForURL:(NSString *)assetURL
{
    if(assetURL.length)
    {
        QuietLog(@"assetURL = %@", assetURL);
        NSURL *url = [NSURL URLWithString:[assetURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *rep = [myasset defaultRepresentation];
            CGImageRef iref = [rep fullResolutionImage];
            if (iref) {
                UIImage *largeImage = [UIImage imageWithCGImage:iref];
                UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 240), NO, 0.0);
                [largeImage drawInRect:CGRectMake(0, 0, 320, 240)];
                largeImage = UIGraphicsGetImageFromCurrentImageContext();
                
                if(![self.mImages objectForKey:assetURL])
                {
                    [self.mImages setObject:[[UIImageView alloc] initWithImage:largeImage] forKey:assetURL];
                }
                QuietLog(@"FOUND IMAGE YAYA");
            }
        };
        
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *myError)
        {
            QuietLog(@"Could not access the asset");
        };
        
        ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
        [assetLibrary assetForURL:url resultBlock:resultblock failureBlock:failureBlock];
    }
    else
    {
        QuietLog(@"reminder did not have an assetURL");
    }
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
        NSTimeInterval intervalUntilFire = [self getTimeIntervalForFrequency:reminder.mRepeatFrequency];
        reminder.mTimer = [NSTimer timerWithTimeInterval:intervalUntilFire target:self selector:@selector(showReminder:) userInfo:reminder repeats:NO];
        reminder.mNotification = [[NotificationManager getInstance] scheduleNewLocalNotification:@"Reminder" WithMsg:[NSString stringWithFormat:@"Reminder: Take %@ %@", reminder.mName, reminder.mQuantity] After:intervalUntilFire];
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

-(NSTimeInterval) getTimeIntervalForFrequency:(RepeatFrequency)frequency
{
    //woooo magic numbers
    switch(frequency)
    {
        case REPEAT_FREQUENCY_NONE:
            return 5;
        case REPEAT_FREQUENCY_DAILY:
            return 86400;
        case REPEAT_FREQUENCY_WEEKLY:
            return 604800;
        default:
            return 5;
    }
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
        thisReminder.mNotification = [[NotificationManager getInstance] scheduleNewLocalNotification:@"Reminder" WithMsg:[NSString stringWithFormat:@"Reminder: Take %@ %@", thisReminder.mName, thisReminder.mQuantity] After:blah];
        [[NSRunLoop currentRunLoop] addTimer:thisReminder.mTimer forMode:NSRunLoopCommonModes];
    }
    else
    {
        NSLog(@"Found reminder");
        [thisReminder.mTimer invalidate];
        thisReminder.mTimer = nil;
        NSTimeInterval blah = [thisReminder.mDate timeIntervalSinceDate:[NSDate date]];
        thisReminder.mTimer = [NSTimer timerWithTimeInterval:blah target:self selector:@selector(showReminder:) userInfo:thisReminder repeats:NO];
        thisReminder.mNotification = [[NotificationManager getInstance] updateLocalNotification:thisReminder.mNotification WithTitle:@"Reminder" WithMsg:[NSString stringWithFormat:@"Reminder: Take %@ %@", thisReminder.mName, thisReminder.mQuantity] After:blah];
        [[NSRunLoop currentRunLoop] addTimer:thisReminder.mTimer forMode:NSRunLoopCommonModes];
    }
    
}


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MedicineReminderModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MedicineReminderModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {

        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
