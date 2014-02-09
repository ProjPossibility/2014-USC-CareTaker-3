//
//  addReminderView.h
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddReminderView : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UINavigationBar *topBar;
    UITableView *mTableView;
    UIScrollView *controlSubView;
    UITextField *nameInput;
    UITextField *amountInput;
    UIDatePicker *datePicker;
    UIButton *choosePhotoButton;
    UIButton *takePhotoButton;
    UIImageView *photoPreviewer;
    NSMutableDictionary *mCellSelectionStatus;
    int nextYCoordForView;
}
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) UINavigationController *rootNavigationController;
-(void)setupControls;
-(void)showImagePickerForSourceType:(id)sender;

@end
