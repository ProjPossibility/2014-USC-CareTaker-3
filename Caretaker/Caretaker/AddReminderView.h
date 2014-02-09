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
    UITableView *controlSubView;
    UIButton *takePhotoButton;
    UIImageView *photoPreviewer;
}
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIButton *choosePhotoButton;
-(void)setupControls;
-(void)showImagePickerForSourceType:(id)sender;

@end
