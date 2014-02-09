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
#import "Reminder.h"

@interface ViewController ()


@end


@implementation ViewController


-(UIButton *)addButtonWithAttributes:(NSString *)title withTarget:(id)target withSelector:(SEL)selector with:(CGSize)bounds
{
    NSDictionary *defaultFontAttributeDic =[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica" size:34.0f] forKey:NSFontAttributeName];
    CGSize stringSize = [title sizeWithAttributes:defaultFontAttributeDic];
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake((bounds.width - stringSize.width)/2, 0, stringSize.width, bounds.height)];
    [newButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setBackgroundColor:[UIColor colorWithRed:0.760784314f green:0.905882353f blue:1.0f alpha:1.0f]];
    [newButton layer].cornerRadius = 4;
    [newButton layer].borderWidth = 1;
    [newButton layer].borderColor = [UIColor colorWithRed:0.360784314f green:0.605882353f blue:1.0f alpha:1.0f].CGColor;
    return newButton;
}

-(void)setupControls
{
    self.controlView = [[UIView alloc] initWithFrame:CGRectMake(0, 65, [[UIScreen mainScreen] bounds].size.width, 100)];
    
    //add show notification button
    self.showNotificationButton = [self addButtonWithAttributes:@"ADD NEW REMINDER" withTarget:self withSelector:@selector(showAddReminder:) with:CGSizeMake(320, 44)];
    [self.controlView addSubview:self.showNotificationButton];
    self.pendingReminders = [[UITableView alloc] initWithFrame:CGRectMake(0, 88, 320, 377) style:UITableViewStylePlain];
    [self.controlView addSubview:self.pendingReminders];
    
    NSString *areYouOkayButtonText = @"Display Warning";
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 44, 320, 44)];
    [newButton addTarget:self action:@selector(showAreYouOkay:) forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:areYouOkayButtonText forState:UIControlStateNormal];
    [newButton setBackgroundColor:[UIColor colorWithRed:0.760784314f green:0.905882353f blue:1.0f alpha:1.0f]];
    [newButton layer].cornerRadius = 4;
    [newButton layer].borderWidth = 1;
    [newButton layer].borderColor = [UIColor colorWithRed:0.360784314f green:0.605882353f blue:1.0f alpha:1.0f].CGColor;
    [self.controlView addSubview:newButton];
    self.pendingReminders.delegate = self;
    self.pendingReminders.dataSource = self;
    
    areYouOkayLackOfResponse = 0;
    
    
    //add the view to the viewcontroller
    [self.view addSubview: self.controlView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.pendingReminders reloadData];
}

-(void)incrementLackOfResponse:(id)sender
{
    areYouOkayLackOfResponse++;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    

    medicineReminder = [[MedicineReminder alloc] init];
    [self setupControls];
    
	// Do any additional setup after loading the view, typically from a nib.
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
    NSTimer *newTimer = [NSTimer timerWithTimeInterval:60.0f target:self selector:@selector(incrementLackOfResponse:) userInfo:Nil repeats:NO];
    //[[]]
    
}


-(void) alertView: ( UIAlertView *) alertView clickedButtonAtIndex: ( NSInteger ) buttonIndex
{
    switch(buttonIndex)
    {
        case 0:
            break;
        case 1:
            break;
        default:
            NSLog(@"THIS SHOUL NEVER EVER EVER HAPPEN");
            break;
    }
}


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
    AddReminderView *addReminderView = [[AddReminderView alloc] init];
    addReminderView.medicineReminder = medicineReminder;
    CATransition* transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATransitionFromTop;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

   [self.navigationController pushViewController:addReminderView animated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [medicineReminder.mImages count];
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
        
        UIView *reminderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        Reminder *currentReminder = [medicineReminder.mReminders objectAtIndex:[indexPath row]];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 320, 44)];
        nameLabel.text = currentReminder.mName;
        nameLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd HH:mm"];
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, 24, 320, 44)];
        dateLabel.text = [formatter stringFromDate:currentReminder.mDate];
        dateLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [reminderView addSubview: nameLabel];
        [reminderView addSubview: dateLabel];
        [cell.contentView addSubview:reminderView];
    }
    
    return cell;
}




@end
