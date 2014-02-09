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
    UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake((bounds.width - stringSize.width)/2, 0, stringSize.width, stringSize.height)];
    [newButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [newButton setTitle:title forState:UIControlStateNormal];
    [newButton setBackgroundColor:[UIColor colorWithRed:0.760784314f green:0.905882353f blue:1.0f alpha:1.0f]];
    [newButton layer].cornerRadius = 4;
    [newButton layer].borderWidth = 1;
    [newButton layer].borderColor = [UIColor colorWithRed:0.360784314f green:0.605882353f blue:1.0f alpha:1.0f].CGColor;
    return newButton;
}

-(void)something:(id)sender
{
    
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


-(void) setupControls
{
    controlSubView = [[UITableView alloc] initWithFrame:CGRectMake((self.view.bounds.size.width - self.view.bounds.size.width * 0.85)/2, (self.view.bounds.size.height - self.view.bounds.size.height * 0.85)/2, self.view.bounds.size.width * 0.85, self.view.bounds.size.height * 0.85)];
    [self.view addSubview:controlSubView];
    self.choosePhotoButton = [self addButtonWithAttributes:@"Choose Photo" withTarget:self withSelector:@selector(showImagePickerForSourceType:) with:controlSubView.bounds.size];
    [controlSubView addSubview:self.choosePhotoButton];
}





@end
