//
//  Reminder.h
//  Caretaker
//
//  Created by Laurence Wong on 2/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

typedef enum RepeatFrequency
{
    REPEAT_FREQUENCY_NONE,
    REPEAT_FREQUENCY_DAILY,
    REPEAT_FREQUENCY_WEEKLY
} RepeatFrequency;

@property int mID;
@property UILocalNotification *mNotification;
@property (nonatomic) NSTimer *mTimer;
@property (nonatomic, strong) NSString *mName;
//@property (nonatomic) int mQuantity;
@property (nonatomic, strong) NSString *mQuantity;
@property (nonatomic) NSDate *mDate;
@property (nonatomic) UIImageView *mImage;
@property (nonatomic) NSString *mImageUid;
@property (nonatomic) BOOL mRepeat;
@property (nonatomic) RepeatFrequency mRepeatFrequency;

+(RepeatFrequency) getRepeatFrequencyFor:(int)index;

@end
