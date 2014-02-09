//
//  addReminderView.m
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "AddReminderView.h"

@implementation AddReminderView

- (id)init
{
    self = [super init];
    if (self) {
        nextYCoordForView = 10;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    UIButton *newButton = [[UIButton alloc] initWithFrame:[self placeViewInScene:stringSize]];
    [newButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setBackgroundColor:[UIColor colorWithRed:0.760784314f green:0.905882353f blue:1.0f alpha:1.0f]];
    [newButton layer].cornerRadius = 4;
    [newButton layer].borderWidth = 1;
    [newButton layer].borderColor = [UIColor colorWithRed:0.360784314f green:0.605882353f blue:1.0f alpha:1.0f].CGColor;
    return newButton;
}

-(CGRect)placeViewInScene:(CGSize)size
{
    CGRect returnRect;
    returnRect.origin.x = (self.view.bounds.size.width - size.width)/2.0f;
    returnRect.origin.y = nextYCoordForView;
    nextYCoordForView += size.height + 10;
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
    photoPreviewer = [[UIImageView alloc] initWithImage:image];
    [controlSubView addSubview:photoPreviewer];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) setupControls
{
    controlSubView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    controlSubView.backgroundColor = [UIColor whiteColor];
    
    datePicker = [[UIDatePicker alloc] initWithFrame:[self placeViewInScene:CGSizeMake(self.view.bounds.size.width, 216)]];
    [controlSubView addSubview:datePicker];
    
    choosePhotoButton = [self addButtonWithAttributes:@"Choose Photo" withTarget:self withSelector:@selector(showImagePickerForSourceType:) with:controlSubView.bounds.size];
    [controlSubView addSubview:choosePhotoButton];
    [self.view addSubview:controlSubView];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}




@end
