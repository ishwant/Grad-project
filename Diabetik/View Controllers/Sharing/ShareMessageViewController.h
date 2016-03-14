//
//  ShareMessageViewController.h
//  Diabetik
//
//  Created by project on 1/28/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareMessageViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendMessageButton;
@property (strong, nonatomic) IBOutlet UITextView *textMessageField;

-(IBAction)sendMessageButtonTapped:(id)sender;
@end
