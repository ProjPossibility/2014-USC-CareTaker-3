//
//  RepeatSelectorViewController.m
//  Caretaker
//
//  Created by Laurence Wong on 2/9/14.
//  Copyright (c) 2014 WirelessWizards. All rights reserved.
//

#import "RepeatSelectorViewController.h"

@interface RepeatSelectorViewController ()

@end

@implementation RepeatSelectorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupTableView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupTableView
{
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview: mTableView];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch([indexPath row])
    {
        case 2:
            return 240;
        case 3:
            return 250;
        default:
            return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"OptionCell%d", indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switch (indexPath.row) {
            case 0:
            {
                UITextField *nameInput = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, 315, 44)];
                [nameInput setPlaceholder:@"Name of medication"];
                [cell.contentView addSubview:nameInput];
                break;
            }
        }
    }
    
    return cell;
}

@end
