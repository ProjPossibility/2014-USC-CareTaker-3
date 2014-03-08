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


@interface ViewController ()
{
    NSNumber *PHONE_ALERT_COOLDOWN;
}

@end


@implementation ViewController


-(UIButton *)addButtonWithAttributes:(NSString *)title withTarget:(id)target withSelector:(SEL)selector with:(CGSize)bounds
{
    NSDictionary *defaultFontAttributeDic =[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica" size:34.0f] forKey:NSFontAttributeName];
    CGSize stringSize = [title sizeWithAttributes:defaultFontAttributeDic];
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake((bounds.width - 280)/2, 0, 300, bounds.height)];
    [newButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]];
    [newButton layer].cornerRadius = 4;
    [newButton layer].borderWidth = 1;
    [newButton layer].borderColor = [UIColor colorWithRed:0.360784314f green:0.605882353f blue:1.0f alpha:1.0f].CGColor;
    return newButton;
}

-(void)setupControls
{
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - 65)];
    
    //add show notification button
    self.showNotificationButton = [self addButtonWithAttributes:@"ADD NEW REMINDER" withTarget:self withSelector:@selector(showAddReminder:) with:CGSizeMake(300, 88)];
    [self.controlView addSubview:self.showNotificationButton];
    self.pendingReminders = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, 320, 420) style:UITableViewStylePlain];
    [self.controlView addSubview:self.pendingReminders];
    
    self.pendingReminders.delegate = self;
    self.pendingReminders.dataSource = self;
    
    areYouOkayLackOfResponse = 0;
    PHONE_ALERT_COOLDOWN = [NSNumber numberWithFloat:1.5];
    onAlertCooldown = NO;
    
    //hide the navbar
    self.navigationController.navigationBarHidden = YES;
    
    //add the view to the viewcontroller
    [self.view addSubview: self.controlView];
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
    
    
    medicineReminder = [[MedicineReminder alloc] init];
    [self setupControls];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"VIEW APPEARED!");
    
    [super viewDidAppear:animated];
    [self.pendingReminders reloadData];
    
    [self startMotionDetect];
    NSLog(@"%@\n%@\n%@", newReminder.mName, newReminder.mQuantity, newReminder.mDate);
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.motionManager stopAccelerometerUpdates];
    
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
                                [self showAreYouOkay:nil];
                                [[NotificationManager getInstance] scheduleNewLocalNotification:@"ALERT: PHONE SHAKE!" After:0];
                                
                                NSTimer *cooldownTimer = [NSTimer timerWithTimeInterval:60.0f target:self selector:@selector(endCooldown) userInfo:Nil repeats:NO];
                                [[NSRunLoop currentRunLoop] addTimer:cooldownTimer forMode:NSRunLoopCommonModes];
                            }
                        }
                        );
     }
     ];
    
}

//

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

-(void)showAddReminder:(id)sender
{
    /*AddReminderView *addReminderView = [[AddReminderView alloc] init];
    addReminderView.medicineReminder = medicineReminder;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFromTop;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    */
    newReminder = [[Reminder alloc] init];
    BaseAddReminderView *addReminderViewPg1 = [[AddReminderViewPg1 alloc] init];
    addReminderViewPg1.reminder = newReminder;
    [self.navigationController pushViewController:addReminderViewPg1 animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//[[medicineReminder mReminders] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[medicineReminder mReminders] count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch([indexPath row])
    {
        default:
            return 64;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"OptionCell%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton *reminderViewButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        Reminder *currentReminder = [medicineReminder.mReminders objectAtIndex:[indexPath row]];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 44)];
        nameLabel.text = currentReminder.mName;
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd HH:mm"];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 24, 320, 44)];
        dateLabel.text = [formatter stringFromDate:currentReminder.mDate];
        dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [reminderViewButton addSubview: nameLabel];
        [reminderViewButton addSubview: dateLabel];
        [reminderViewButton addTarget:self action:@selector(showAreYouOkay:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:reminderViewButton];
    }
    
    return cell;
}




@end
