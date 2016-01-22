//
//  SelectPostViewController.m
//  Diabetik
//
//  Created by project on 1/17/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "SelectPostViewController.h"
#import "UAEventInputViewCell.h"
#import "UAKeyboardShortcutAccessoryView.h"
#import "ShareViewController.h"

@implementation SelectPostViewController
@synthesize  categoryField, startDateField, endDateField, searchPostButton;

//INITIAL SETUP
/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"SelectPostViewController loading");
    self.title = @"SHARE";
    _datePicker.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TABLE VIEW SETUP

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
 
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.row == 0){
        
        _datePicker.hidden = YES;
        self.categoryField = [[UITextField alloc] initWithFrame:CGRectMake(65, 20, 200, 30)];
        self.categoryField.placeholder = @"Select Category";
        self.categoryField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.categoryField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.categoryField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell addSubview:self.categoryField];
    }
    if (indexPath.row == 1){
        

        self.startDateField = [[UITextField alloc] initWithFrame:CGRectMake(65, 20, 200, 30)];
        self.startDateField.placeholder = @"Select Start Date";
        self.startDateField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.startDateField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.startDateField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell addSubview:self.startDateField];
        
         self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
   //     [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker setDate:[NSDate date]];
        [self.datePicker addTarget:self action:@selector(updatestartDateField:) forControlEvents:UIControlEventValueChanged];
        
        startDateField.inputView = self.datePicker;
    }
    if (indexPath.row == 2){
        

        self.endDateField = [[UITextField alloc] initWithFrame:CGRectMake(65, 20, 200, 30)];
        self.endDateField.placeholder = @"Select End Date";
        self.endDateField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.endDateField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.endDateField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell addSubview:self.endDateField];

        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
        //     [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker setDate:[NSDate date]];
        [self.datePicker addTarget:self action:@selector(updateendDateField:) forControlEvents:UIControlEventValueChanged];

        endDateField.inputView = self.datePicker;
    }
    if (indexPath.row == 3){
        
        self.searchPostButton = [[UIButton alloc] initWithFrame:CGRectMake(65,20,200,30)];
        [self.searchPostButton setBackgroundColor:[UIColor blackColor]];
        [self.searchPostButton addTarget:self action:@selector(searchPostButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchPostButton setTitle:@"Search Posts" forState:UIControlStateNormal];

        [cell addSubview:self.searchPostButton];
    }
    return cell;
}

-(IBAction)searchPostButtonTapped:(id)sender{
    
    NSLog(@"ENTERING");
    
    if(![categoryField hasText] || ![startDateField hasText] || ![endDateField hasText]){
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete entries" message:@"Please fill all the details" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [self.alertView show];
    }
    else {
        NSLog(@"Entered else part");
        NSLog(@"Entered Category: %@", categoryField.text);
        NSLog(@"Entered StartDate: %@", startDateField.text);
        NSLog(@"Entered EndDate: %@", endDateField.text);
        
        //set time to 00 hrs
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comps = [calendar components:unitFlags fromDate:self.searchStartDate];
        comps.hour   = 00;
        comps.minute = 00;
        comps.second = 00;
        self.searchStartDate = [calendar dateFromComponents:comps];
        
        NSDateComponents *comps1 = [calendar components:unitFlags fromDate:self.searchEndDate];
        comps1.hour   = 23;
        comps1.minute = 59;
        comps1.second = 59;
        self.searchEndDate = [calendar dateFromComponents:comps1];
        
        //Push view controller
        ShareViewController *vc = [[ShareViewController alloc] init];
        vc.searchCategory = categoryField.text;
        vc.searchStartDate = self.searchStartDate;
        vc.searchEndDate = self.searchEndDate;
        [[self navigationController] pushViewController:vc animated:YES];
    }
}
    
- (void)updatestartDateField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.startDateField.inputView;
    self.searchStartDate = picker.date;
    self.startDateField.text = [self formatDate:picker.date];
}
- (void)updateendDateField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.endDateField.inputView;
    self.searchEndDate = picker.date;
    self.endDateField.text = [self formatDate:picker.date];
}

// Formats the date chosen with the date picker.
- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}


//UI CUSTOMIZATION

- (UIColor *)tintColor
{
    return [UIColor colorWithRed:127.0f/255.0f green:192.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
}
@end
