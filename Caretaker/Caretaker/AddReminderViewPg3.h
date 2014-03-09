//
//  AddReminderViewPg3.h
//  Caretaker
//
//  Created by Laurence Wong on 3/7/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "BaseAddReminderView.h"

@interface AddReminderViewPg3 : BaseAddReminderView <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* mRepeatFrequencyData;
}

@property (nonatomic, strong)   UIDatePicker *datePicker;
@property (nonatomic, strong)   UILabel *mCurrentSelectedRepeat;
@property (nonatomic, strong)   UITableView *mRepeatSelector;
@end
