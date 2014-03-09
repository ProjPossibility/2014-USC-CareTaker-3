//
//  addReminderView.h
//  Caretaker
//
//  Created by Laurence Wong on 2/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MedicineReminder.h"

@interface AddReminderView : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *mTableView;
    UIScrollView *controlSubView;
    UITextField *nameInput;
    UITextField *amountInput;
    UIDatePicker *datePicker;
    UIButton *choosePhotoButton;
    UIButton *reminderFreqButton;
    UIButton *goBackButton;
    UIImageView *photoPreviewer;
    NSString *photoUid;
    int nextYCoordForView;
    BOOL repeatDaily;
}
@property (nonatomic) IBOutlet UIView *overlayView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic) MedicineReminder *medicineReminder;
//@property (nonatomic)

-(void)setupControls;
-(void)showImagePickerForSourceType:(id)sender;
//-(void)goBackButtonAction:(id)sender;

@end
