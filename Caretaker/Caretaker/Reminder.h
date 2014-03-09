//
//  Reminder.h
//  Caretaker
//
//  Created by Laurence Wong on 2/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property int mID;
@property (nonatomic) NSTimer *mTimer;
@property (nonatomic, strong) NSString *mName;
//@property (nonatomic) int mQuantity;
@property (nonatomic, strong) NSString *mQuantity;
@property (nonatomic) NSDate *mDate;
@property (nonatomic) UIImageView *mImage;
@property (nonatomic) NSString *mImageUid;
@property (nonatomic) BOOL mRepeat;

@end
