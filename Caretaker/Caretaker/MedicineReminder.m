//
//  MedicineReminder.m
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "MedicineReminder.h"

@implementation MedicineReminder

- (id)init
{
    self = [super init];
    if (self) {
        [self showReminder:@"JAJA"];
    }
    return self;
}
- (void)showReminder:(NSString *)text
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Reminder" message:text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 220, 137)];
    
    UIImage *image= [UIImage imageNamed:@"pills.png"];
    [imageView setImage:image];
    
    [alertView setValue:imageView forKey:@"accessoryView"];
    
    [alertView addSubview:imageView];
    
    [alertView show];
}

-(void)timerEvent
{
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"AHHHHHHHH A NOTIFICATION!";
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.hasAction = NO;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reload" object:self];

}

@end
