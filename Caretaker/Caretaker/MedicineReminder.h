//
//  MedicineReminder.h
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicineReminder : NSObject
{
}

@property (nonatomic, strong) NSMutableDictionary *mImages;
@property (nonatomic, strong) NSMutableArray *mReminders;


-(void)addReminderWith:(NSString *)name and:(int)quantity and:(NSDate *)date and:(BOOL)repeat and:(NSString *)imageUid;

@end
