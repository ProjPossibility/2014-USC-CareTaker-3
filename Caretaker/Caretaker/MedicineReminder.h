//
//  MedicineReminder.h
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Reminder.h"

@interface MedicineReminder : NSObject
{
}

@property (nonatomic, strong) NSMutableDictionary *mImages;
@property (nonatomic, strong) NSMutableArray *mReminders;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;


+(MedicineReminder*) getInstance;
-(void)addReminderWith:(Reminder*)thisReminder;
-(void)dumpRemindersToDatabase;
-(Reminder *)getNewReminder;
-(void)deleteReminder:(Reminder*)inReminder;

@end
