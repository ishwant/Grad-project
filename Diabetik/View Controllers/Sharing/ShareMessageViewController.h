//
//  ShareMessageViewController.h
//  Diabetik
//
//  Created by project on 1/28/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareMessageViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (strong, nonatomic) IBOutlet UITextField *textMessageField;

-(IBAction)sendMessageButtonTapped:(id)sender;
@end
