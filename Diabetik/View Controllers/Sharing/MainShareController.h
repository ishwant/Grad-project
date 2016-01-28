//
//  SelectPostViewController.h
//  Diabetik
//
//  Created by project on 1/17/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"

@interface MainShareController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *postButton;
@property (strong, nonatomic) IBOutlet UIButton *messageButton;

@property (nonatomic,retain) UIAlertView *alertView;

@end