//
//  SelectPostViewController.h
//  Diabetik
//
//  Created by project on 1/17/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAInputBaseViewController.h"
#import "ShareViewController.h"

@interface SelectPostViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *categoryField;
@property (strong, nonatomic) IBOutlet UITextField *startDateField;
@property (strong, nonatomic) IBOutlet UITextField *endDateField;
@property (strong, nonatomic) IBOutlet UIButton *searchPostButton;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *searchStartDate;
@property (strong, nonatomic) NSDate *searchEndDate;
@property (strong, nonatomic) NSMutableArray *categories;

@property (nonatomic,retain) UIAlertView *alertView;

@end