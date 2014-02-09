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
    NSTimer *tempTimer;
    NSMutableDictionary *imageDictionary;
}

-(void)timerEvent;
-(void)addReminder;

@end
