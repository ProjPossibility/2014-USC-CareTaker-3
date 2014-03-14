//
//  Reminder.m
//  Caretaker
//
//  Created by Laurence Wong on 2/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "Reminder.h"
#import <Accelerate/Accelerate.h>

@implementation Reminder

+(RepeatFrequency) getRepeatFrequencyFor:(int)index
{
    switch(index)
    {
        case 0:
            return REPEAT_FREQUENCY_NONE;
        case 1:
            return REPEAT_FREQUENCY_DAILY;
        case 2:
            return REPEAT_FREQUENCY_WEEKLY;
        default:
            return REPEAT_FREQUENCY_NONE;
    }
}

+(int) getIndexForRepeatFrequency:(RepeatFrequency)repeatFrequency
{
    switch(repeatFrequency)
    {
        case REPEAT_FREQUENCY_NONE:
            return 0;
        case REPEAT_FREQUENCY_DAILY:
            return 1;
        case REPEAT_FREQUENCY_WEEKLY:
            return 2;
        default:
            return 0;
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.mRepeatFrequency = REPEAT_FREQUENCY_NONE;
    }
    return self;
}

- (void)dealloc
{
    QuietLog(@"Deleting reminder for %@", self.mName);

}

@end
