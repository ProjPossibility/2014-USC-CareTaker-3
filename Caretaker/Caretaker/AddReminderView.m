//
//  addReminderView.m
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "AddReminderView.h"
#import "ViewController.h"

@implementation AddReminderView

- (id)init
{
    self = [super init];
    if (self) {
        nextYCoordForView = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    repeatDaily = YES;
    self.navigationItem.leftBarButtonItem = nil;
    [self setupControls];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)addButtonWithAttributes:(NSString *)title withTarget:(id)target withSelector:(SEL)selector with:(CGSize)bounds
{
    UIButton *newButton = [[UIButton alloc] initWithFrame:[self placeViewInScene:bounds]];
    [newButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton layer].cornerRadius = 4;
    [newButton setTitleColor:[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f] forState:UIControlStateNormal];
    return newButton;
}

-(CGRect)placeViewInScene:(CGSize)size
{
    CGRect returnRect;
    returnRect.origin.x = (self.view.bounds.size.width - size.width)/2.0f;
    returnRect.origin.y = nextYCoordForView;
    nextYCoordForView += size.height + 5;
    returnRect.size.width = size.width;
    returnRect.size.height = size.height;
    return returnRect;
}


- (void)showImagePickerForSourceType:(id)sender
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.delegate = self;
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    photoUid = [info valueForKey:UIImagePickerControllerReferenceURL];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 240), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, 320, 240)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *newImageView = [[UIImageView alloc] initWithImage:image];
    [self.medicineReminder.mImages setObject:newImageView forKey:photoUid];
    //photoPreviewer = [[UIImageView alloc] initWithImage:image];
    [choosePhotoButton setBackgroundImage:newImageView.image forState:UIControlStateNormal];
    [choosePhotoButton setTitle:@"" forState:UIControlStateNormal];
    [controlSubView addSubview:photoPreviewer];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) displayWarning:(NSString *)warningText
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = warningText;
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.hasAction = NO;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

-(void) confirmFields:(id)sender
{
    if([nameInput.text length] == 0)
    {
        [self displayWarning:@"No name was entered"];
        return;
    }
    if([amountInput.text length] == 0)
    {
        [self displayWarning:@"No quantity was entered"];
        return;
    }
    
    //do something with the values
    [self.medicineReminder addReminderWith:nameInput.text and:[amountInput.text intValue] and:datePicker.date and:repeatDaily and:photoUid];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void) setupControls
{
    controlSubView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    controlSubView.backgroundColor = [UIColor whiteColor];

    
    mTableView = [[UITableView alloc] initWithFrame:[self placeViewInScene:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)]];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [controlSubView addSubview: mTableView];
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(confirmFields:)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
    [self.view addSubview:controlSubView];
    
}

- (void)goBackButtonAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
    return 7;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch([indexPath row])
    {
        case 2:
            return 240;
        case 3:
            return 250;
        default:
            return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 5)
    {
        repeatDaily = !repeatDaily;
    }
    [mTableView reloadData];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"OptionCell%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
            {
                goBackButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 310, 44)];
                [goBackButton setTitle:@"Go Back" forState:UIControlStateNormal];
                goBackButton.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f];
                [goBackButton addTarget:self action:@selector(goBackButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:goBackButton];
                break;
            }
            case 1:
            {
                nameInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 315, 44)];
                [nameInput setPlaceholder:@"Name of medication"];
                [cell.contentView addSubview:nameInput];
                break;
            }
            case 2:
                amountInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 315, 44)];
                amountInput.keyboardType = UIKeyboardTypeDecimalPad;
                [amountInput setPlaceholder:@"Quantity"];
                //amountInput.borderStyle = UITextBorderStyleRoundedRect
                [cell.contentView addSubview:amountInput];
                break;
                
            case 3:
            {
                nextYCoordForView = 0;
                choosePhotoButton = [self addButtonWithAttributes:@"Choose Picture" withTarget:self withSelector:@selector(showImagePickerForSourceType:) with:CGSizeMake(320, 240)];
                [cell.contentView addSubview:choosePhotoButton];
                break;
            }
                
            case 4:
            {
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 315, 35)];
                dateLabel.text = @"Enter Date";
                dateLabel.textColor =[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f];

                datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 35, 320, 216)];
                [cell.contentView addSubview:dateLabel];
                [cell.contentView addSubview:datePicker];
                break;
            }
            case 5:
                cell.frame = CGRectMake(0, 0, self.view.bounds.size.width, 44);
                cell.textLabel.text = @"Repeat Daily";
                cell.textLabel.textColor =[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:1.0f];
                cell.accessoryType = repeatDaily ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                [cell.contentView addSubview:reminderFreqButton];
                break;
            default:
                break;
                
                
        }
    }
    switch (indexPath.row) {
        case 0:
        {
            break;
        }
        case 1:
            break;
            
        case 2:
        {
            break;
        }
            
        case 3:
        {
            break;
        }
        case 5:
            cell.accessoryType = repeatDaily ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        default:
            break;
            
            
    }

    return cell;
}



@end
