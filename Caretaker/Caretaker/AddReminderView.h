//
//  addReminderView.h
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddReminderView : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIScrollView *controlSubView;
    UIDatePicker *datePicker;
    UIButton *choosePhotoButton;
    UIButton *takePhotoButton;
    UIImageView *photoPreviewer;
    int nextYCoordForView;
}
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) UIImagePickerController *imagePickerController;
-(void)setupControls;
-(void)showImagePickerForSourceType:(id)sender;

@end
