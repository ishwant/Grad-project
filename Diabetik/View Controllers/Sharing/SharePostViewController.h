//
//  SharePostViewController.h
//  Diabetik
//
//  Created by project on 1/15/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SharePostViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@end
