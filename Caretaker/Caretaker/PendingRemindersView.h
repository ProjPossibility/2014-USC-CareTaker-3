//
//  PendingRemindersView.h
//  Caretaker
//
//  Created by Laurence Wong on 3/8/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PendingRemindersView : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIButton *goBackButton;
    UIView *controlView;
    UITableView *mPendingReminders;
}
@end
