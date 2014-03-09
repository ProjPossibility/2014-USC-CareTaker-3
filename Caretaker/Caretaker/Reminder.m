//
//  Reminder.m
//  Caretaker
//
//  Created by Laurence Wong on 2/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "Reminder.h"

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

- (id)init
{
    self = [super init];
    if (self) {
        self.mRepeatFrequency = REPEAT_FREQUENCY_NONE;
    }
    return self;
}

@end
