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
        nextYCoordForView = 20;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    mCellSelectionStatus = [[NSMutableDictionary alloc] init];
    [self setupControls];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIButton *)addButtonWithAttributes:(NSString *)title withTarget:(id)target withSelector:(SEL)selector with:(CGSize)bounds
{
    NSDictionary *defaultFontAttributeDic =[NSDictionary dictionaryWithObject:[UIFont fontWithName:@"Helvetica" size:34.0f] forKey:NSFontAttributeName];
    CGSize stringSize = [title sizeWithAttributes:defaultFontAttributeDic];
    UIButton *newButton = [[UIButton alloc] initWithFrame:[self placeViewInScene:bounds]];
    [newButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:title forState:UIControlStateNormal];
    //[newButton setBackgroundColor:[UIColor colorWithRed:0.760784314f green:0.905882353f blue:1.0f alpha:1.0f]];
    [newButton layer].cornerRadius = 4;
    //[newButton layer].borderWidth = 1;
    //[newButton layer].borderColor = [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:1.0f].CGColor;
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
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(320, 240), NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, 320, 240)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
//    photoPreviewer = [[UIImageView alloc] initWithImage:image];
    [choosePhotoButton setBackgroundImage:image forState:UIControlStateNormal];
    [controlSubView addSubview:photoPreviewer];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) dismissView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) pushNewView:(id)sender
{
    UIViewController *newUIView = [[UIViewController alloc] init];
    newUIView.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    newUIView.view.backgroundColor = [UIColor blackColor];
    [self.rootNavigationController pushViewController:newUIView animated:YES];
}

-(void) setupControls
{
    controlSubView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    controlSubView.backgroundColor = [UIColor whiteColor];
    
    
    topBar = [[UINavigationBar alloc] initWithFrame:[self placeViewInScene:CGSizeMake(320, 44)]];
    topBar.backgroundColor = [UIColor whiteColor];
    UINavigationItem *uiNavItem = [[UINavigationItem alloc] init];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissView:)];
    [uiNavItem setLeftBarButtonItem:backButton];
    NSArray *uiNavItems = [[NSArray alloc] initWithObjects:uiNavItem, nil];
    [topBar setItems:uiNavItems animated:YES];
    
    [controlSubView addSubview:topBar];
    
    mTableView = [[UITableView alloc] initWithFrame:[self placeViewInScene:[UIScreen mainScreen].bounds.size]];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [controlSubView addSubview: mTableView];

    [self.view addSubview:controlSubView];
    
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
    return 4;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch([indexPath row])
    {
        case 0:
            return 44;
        case 1:
            return 44;
        case 2:
            return 240;
        case 3:
            return 300;
        default:
            return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"OptionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    UISwitch *toggleSwitch = [[UISwitch alloc] init];
    
    switch (indexPath.row) {
        case 0:
        {
            nameInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 315, 44)];
            [nameInput setPlaceholder:@"Name"];
            //nameInput.borderStyle = UITextBorderStyleRoundedRect;
            [cell.contentView addSubview:nameInput];
            break;
        }
        case 1:
            amountInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 315, 44)];
            amountInput.keyboardType = UIKeyboardTypeDecimalPad;
            [amountInput setPlaceholder:@"Quantity"];
            //amountInput.borderStyle = UITextBorderStyleRoundedRect;
            [cell.contentView addSubview:amountInput];
            break;
            
        case 2:
        {
            nextYCoordForView = 0;
            choosePhotoButton = [self addButtonWithAttributes:@"Choose Photo" withTarget:self withSelector:@selector(showImagePickerForSourceType:) with:CGSizeMake(320, 240)];
            [cell.contentView addSubview:choosePhotoButton];
            break;
        }
            
        case 3:
        {
            UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 315, 35)];
            dateLabel.text = @"Enter Date";
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 35, 320, 216)];
            [cell.contentView addSubview:dateLabel];
            [cell.contentView addSubview:datePicker];
            break;
        }
            
    }
    return cell;
}




@end
