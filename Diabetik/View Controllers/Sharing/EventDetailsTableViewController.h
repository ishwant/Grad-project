//
//  EventDetailsTableViewController.h
//  Diabetik
//
//  Created by project on 3/5/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAInputBaseViewController.h"
#import "ShareViewController.h"

@interface EventDetailsTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *details;
@property (strong, nonatomic) NSMutableArray *selectedDetails;
@property (strong, nonatomic) NSMutableArray *selectedEvents;
@property (strong, nonatomic) NSString *selectedDetailsString;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (strong, nonatomic) NSString *loggedInUserToken;

@property (nonatomic,retain) UIAlertView *alertView;
@property (strong, nonatomic) IBOutlet UITextField *textMessageField;
@end
