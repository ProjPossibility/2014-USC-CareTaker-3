//
//  ViewController.m
//  Caretaker
//
//  Created by Francesca Nannizzi on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "ViewController.h"
#import "AddReminderView.h"
#import "AppDelegate.h"
#import <CoreMotion/CoreMotion.h>
#import "NotificationManager.h"
#import "AddReminderViewPg1.h"
#import "PendingRemindersView.h"
#import "AreYouOkayManager.h"


@interface ViewController ()
{
    NSNumber *PHONE_ALERT_COOLDOWN;
}

@end


@implementation ViewController


-(UIButton *)addButtonWithAttributes:(NSString *)title withTarget:(id)target withSelector:(SEL)selector with:(CGRect)bounds
{
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake((bounds.size.width - 280)/2, bounds.origin.y, 300, bounds.size.height)];
    [newButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setBackgroundColor:[UIColor colorWithRed:0.729 green:0.243f blue:0.255f alpha:1.0f]];
    [newButton layer].cornerRadius = 4;
    [newButton layer].borderWidth = 1;
    [newButton layer].borderColor = [UIColor colorWithRed:0.360784314f green:0.605882353f blue:1.0f alpha:1.0f].CGColor;
    return newButton;
}

-(void)sendTextMessageToNumber
{
    NSString *restCallString = [NSString stringWithFormat:@"http://caretakerapp.herokuapp.com/helloWorld?number=%@&message=%@", emergencyNumber, @"AAAAAHHH_EMERGENCY_STUFFF_AAAAAHH_CROISSANT"];
    
    NSURL *restURL = [NSURL URLWithString:restCallString];
    NSURLRequest *restRequest = [NSURLRequest requestWithURL:restURL];

    if(currentConnection)
    {
        [currentConnection cancel];
        currentConnection = nil;
    }
    
    currentConnection = [[NSURLConnection alloc] initWithRequest:restRequest delegate:self];
    

}

-(void)setupControls
{
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 65)];
    
    //add show notification button
    self.showNotificationButton = [self addButtonWithAttributes:@"ADD NEW REMINDER" withTarget:self withSelector:@selector(showAddReminder:) with:CGRectMake(0, 0, 300, 88)];
    [self.controlView addSubview:self.showNotificationButton];
    
    self.showPendingRemindersButton = [self addButtonWithAttributes:@"SHOW PENDING REMINDERS" withTarget:self withSelector:@selector(showPendingReminders) with:CGRectMake(0, 98, 300, 88)];
    [self.controlView addSubview:self.showPendingRemindersButton];
    
    self.sendTextMessageButton = [self addButtonWithAttributes:@"SEND TEXT MESSAGE" withTarget:self withSelector:@selector(sendTextMessageToNumber) with:CGRectMake(0, 188, 300, 88)];
    [self.controlView addSubview:self.sendTextMessageButton];
    
    areYouOkayLackOfResponse = 0;
    PHONE_ALERT_COOLDOWN = [NSNumber numberWithFloat:1.5];
    onAlertCooldown = NO;
    
    //hide the navbar
    self.navigationController.navigationBarHidden = YES;
    
    //add the view to the viewcontroller
    [self.view addSubview: self.controlView];
    
    emergencyNumber = @"6263722112";
}

-(void)reEvaluateLackOfResponse
{
    switch(areYouOkayLackOfResponse)
    {
        case 1:
            //AudioServicesPlayAlertSound);
            break;
        case 2:
            break;
            
    }
}

-(void)incrementLackOfResponse:(id)sender
{
    areYouOkayLackOfResponse++;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    accelLoggerPhone = [[AccelerationLogger alloc] initWithFileFlair:@"Phone"];
    
    [self setupControls];
    [self startMotionDetect];
    [MedicineReminder getInstance];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"VIEW APPEARED!");
    
    [super viewDidAppear:animated];
    
    if([newReminder.mName length])
    {
        [[MedicineReminder getInstance] addReminderWith:newReminder];
        newReminder = [[Reminder alloc] init];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.motionManager stopAccelerometerUpdates];
    
}

- (void)writeDataToFile
{
    QuietLog(@"ViewController is writing out data");
    
    [[MedicineReminder getInstance] dumpRemindersToDatabase];
    
    QuietLog(@"ViewController finished writing out data");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAreYouOkay:(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WARNING" message:[NSString stringWithFormat:@"Are you okay?"] delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    alertView.delegate = self;
    [alertView show];
    areYouOkayTimer = [NSTimer timerWithTimeInterval:[PHONE_ALERT_COOLDOWN floatValue] target:self selector:@selector(incrementLackOfResponse:) userInfo:Nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:areYouOkayTimer forMode:NSRunLoopCommonModes];
    
}


-(void) alertView: ( UIAlertView *) alertView clickedButtonAtIndex: ( NSInteger ) buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            [areYouOkayTimer invalidate];
            break;
        case 1:
            [areYouOkayTimer invalidate];
            break;
        default:
            NSLog(@"THIS SHOUL NEVER EVER EVER HAPPEN");
            break;
    }
}

- (void)endCooldown
{
    onAlertCooldown = NO;
}

//Motion
- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}


- (void)startMotionDetect
{
    
    self.motionManager.accelerometerUpdateInterval = 0.1f;
    [self.motionManager
     startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init]
     withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{   //Will be called with data and error
                            QuietLog(@"PHONE  X: %.2f, Y: %.2f, Z: %.2f", data.acceleration.x, data.acceleration.y, data.acceleration.z);
                            [accelLoggerPhone logData:data];
                            if((fabs(data.acceleration.z) > 2.5 || fabs(data.acceleration.x) > 2.5) && !onAlertCooldown) {
                                //[self showAreYouOkay:nil];
                                [[AreYouOkayManager getInstance] scheduleAreYouOkayAfter:0];
                                [[NotificationManager getInstance] scheduleNewLocalNotification:@"Alert!" WithMsg:@"ALERT: PHONE SHAKE!" After:0];
                                [accelLoggerPhone logString:@"PHONE SHAKE ALERT"];
                                
                                NSTimer *cooldownTimer = [NSTimer timerWithTimeInterval:60.0f target:self selector:@selector(endCooldown) userInfo:Nil repeats:NO];
                                [[NSRunLoop currentRunLoop] addTimer:cooldownTimer forMode:NSRunLoopCommonModes];
                            }
                        }
                        );
     }
     ];
    
}

-(void)showPendingReminders
{
    PendingRemindersView *newPendingRemindersView = [[PendingRemindersView alloc] init];
    [self.navigationController pushViewController:newPendingRemindersView animated:YES];
    
}

-(void)showAddReminder:(id)sender
{
    newReminder = [[Reminder alloc] init];
    BaseAddReminderView *addReminderViewPg1 = [[AddReminderViewPg1 alloc] init];
    addReminderViewPg1.reminder = newReminder;
    addReminderViewPg1.rootView = self;
    [self.navigationController pushViewController:addReminderViewPg1 animated:YES];
}

@end
