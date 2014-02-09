//
//  Reminder.h
//  Caretaker
//
//  Created by Laurence Wong on 2/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property (nonatomic, strong) NSString *mName;
@property (nonatomic) int mQuantity;
@property (nonatomic) NSDate *mDate;
@property (nonatomic, strong) UIImageView *mPicture;
@property (nonatomic) BOOL mRepeat;

@end
