//
//  MedicineReminder.h
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reminder.h"

@interface MedicineReminder : NSObject
{
}

@property (nonatomic, strong) NSMutableDictionary *mImages;
@property (nonatomic, strong) NSMutableArray *mReminders;


+(MedicineReminder*) getInstance;
-(void)addReminderWith:(Reminder*)thisReminder;
-(Reminder *)getNewReminder;

@end
