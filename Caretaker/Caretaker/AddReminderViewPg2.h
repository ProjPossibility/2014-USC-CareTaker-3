//
//  AddReminderViewPg2.h
//  Caretaker
//
//  Created by Laurence Wong on 3/7/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "BaseAddReminderView.h"

@interface AddReminderViewPg2 : BaseAddReminderView <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, strong)     UIButton *choosePhotoButton;
@property (nonatomic) UIImagePickerController *imagePickerController;

@end
