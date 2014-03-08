//
//  AddReminderViewPg2.m
//  Caretaker
//
//  Created by Laurence Wong on 3/7/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "AddReminderViewPg2.h"
#import "AddReminderViewPg3.h"

@interface AddReminderViewPg2 ()

@end

@implementation AddReminderViewPg2

- (id)init
{
    self = [super init];
    if (self) {
        [self initControlView];
    }
    return self;
}

- (void)goBackButtonAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextButtonAction:(id)sender
{
    self.reminder.mImage = self.choosePhotoButton.imageView;
    AddReminderViewPg3 *newReminderViewPg3 = [[AddReminderViewPg3 alloc] init];
    newReminderViewPg3.reminder = self.reminder;
    [self.navigationController pushViewController:newReminderViewPg3 animated:YES];
}


- (void) initControlView
{
    
    self.choosePhotoButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 80, SCWIDTH - 10, SCWIDTH - 10)];

    [self.choosePhotoButton setBackgroundColor:[UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:1.0f]];
    [self.choosePhotoButton setTitle:@"Choose A Photo" forState:UIControlStateNormal];
    [self.choosePhotoButton addTarget:self action:@selector(showImagePickerForSourceType:) forControlEvents:UIControlEventTouchUpInside];
    [self.choosePhotoButton layer].borderWidth = 1.0f;
    [self.controlView addSubview:self.choosePhotoButton];
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
    //photoPreviewer = [[UIImageView alloc] initWithImage:image];
    [self.choosePhotoButton setBackgroundImage:image forState:UIControlStateNormal];
    [self.choosePhotoButton setTitle:@"" forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
