//
//  AreYouOkayManager.m
//  Caretaker
//
//  Created by Laurence Wong on 3/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "AreYouOkayManager.h"
#import "NotificationManager.h"
#import "ClassificationController.h"
#import <AudioToolbox/AudioServices.h>

@implementation AreYouOkayManager

+ (AreYouOkayManager*) getInstance
{
    static AreYouOkayManager *instance;
    
    if(!instance)
    {
        instance = [[AreYouOkayManager alloc] init];
    }
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        PHONE_ALERT_COOLDOWN = [NSNumber numberWithFloat:60];
        mCurrentAlertLevel = 0;
    }
    return self;
}

-(void) scheduleAreYouOkayAfter:(NSTimeInterval)after
{
    if(!hasAreYouOkayBeenScheduled)
    {
        areYouOkayTimer = [NSTimer timerWithTimeInterval:0 target:self selector:@selector(increaseAreYouOkayAlert) userInfo:Nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:areYouOkayTimer forMode:NSRunLoopCommonModes];
        
        hasAreYouOkayBeenScheduled = YES;
    }
}

-(void)sendTextMessageToNumber
{
    NSString *restCallString = [NSString stringWithFormat:@"http://caretakerapp.herokuapp.com/helloWorld?number=%@&message=%@", self.emergencyContactPhone, @"ALERT FROM CARETAKER APP: Your relative "];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];
    
    if(currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
    }
    
    currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
}

-(void) vibratePhone
{
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

-(void) increaseAreYouOkayAlert
{
    if(currentAlertView)
    {
        [currentAlertView dismissWithClickedButtonIndex:3 animated:YES];
        currentAlertView = nil;
        [areYouOkayTimer invalidate];
        areYouOkayTimer = nil;
    }
    mCurrentAlertLevel++;
    switch(mCurrentAlertLevel)
    {
        case 1:
        {
            currentAlertView = [[UIAlertView alloc] initWithTitle:@"WARNING" message:[NSString stringWithFormat:@"ALERT LEVEL 1: Are you okay?"] delegate:self cancelButtonTitle:@"YES, I didn't fall down" otherButtonTitles:@"YES, but I did fall down", @"NO, I'm not okay", nil];
            currentAlertView.delegate = self;
            areYouOkayTimer = [NSTimer timerWithTimeInterval:[PHONE_ALERT_COOLDOWN floatValue] target:self selector:@selector(increaseAreYouOkayAlert) userInfo:Nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:areYouOkayTimer forMode:NSRunLoopCommonModes];
            [currentAlertView show];
            break;
        }
        case 2:
        {
            currentAlertView = [[UIAlertView alloc] initWithTitle:@"WARNING" message:[NSString stringWithFormat:@"ALERT LEVEL 2: Are you okay?"] delegate:self cancelButtonTitle:@"YES, I didn't fall down" otherButtonTitles:@"YES, but I did fall down", @"NO, I'm not okay", nil];
            currentAlertView.delegate = self;
            
            vibrateTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(vibratePhone) userInfo:Nil repeats:YES];
            areYouOkayTimer = [NSTimer timerWithTimeInterval:[PHONE_ALERT_COOLDOWN floatValue] target:self selector:@selector(increaseAreYouOkayAlert) userInfo:Nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:areYouOkayTimer forMode:NSRunLoopCommonModes];
            [[NSRunLoop currentRunLoop] addTimer:vibrateTimer forMode:NSRunLoopCommonModes];
            [currentAlertView show];
            break;
        }
        case 3:
        {
            currentAlertView = [[UIAlertView alloc] initWithTitle:@"WARNING" message:[NSString stringWithFormat:@"ALERT LEVEL 3: Are you okay?"] delegate:self cancelButtonTitle:@"YES, I didn't fall down" otherButtonTitles:@"YES, but I did fall down", @"NO, I'm not okay", nil];
            currentAlertView.delegate = self;
            areYouOkayTimer = [NSTimer timerWithTimeInterval:[PHONE_ALERT_COOLDOWN floatValue] target:self selector:@selector(sendTextMessageToNumber) userInfo:Nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:areYouOkayTimer forMode:NSRunLoopCommonModes];
            [currentAlertView show];
            break;
        }
    }
}

-(void) resetPendingNotificationLock
{
    [areYouOkayTimer invalidate];
    areYouOkayTimer = nil;
    mCurrentAlertLevel = 0;
    [vibrateTimer invalidate];
    vibrateTimer = nil;
    hasAreYouOkayBeenScheduled = NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    ClassificationController *classificationController = [ClassificationController getInstance];

    switch(buttonIndex)
    {
        case 1:
            QuietLog(@"Clicked YES, I did fall down");
            [self resetPendingNotificationLock];
            [classificationController messageYes];
            break;
        case 2:
            QuietLog(@"Clicked YES, I fell down and I'm not okay");
            [self resetPendingNotificationLock];
            [classificationController messageYes];
            break;
        case 0:
            QuietLog(@"Clicked NO, I didn't fall down");
            [self resetPendingNotificationLock];
            [classificationController messageNo];
            break;
        default:
            break;
    }
}

@end
