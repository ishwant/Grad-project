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

UIGestureRecognizer *tap;
@implementation SelectPostViewController
@synthesize  startDateField, endDateField, searchPostButton, categories;
@synthesize tableView = _tableView;

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    NSLog(@"SelectPostViewController loading");
    self.title = @"SHARE";
    
/*    self.searchPostButton = [[UIButton alloc] initWithFrame:CGRectMake(65,20,200,30)];
    [self.searchPostButton setBackgroundColor:[UIColor blackColor]];
    [self.searchPostButton addTarget:self action:@selector(searchPostButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchPostButton setTitle:@"Search Posts" forState:UIControlStateNormal];
    
    [cell addSubview:self.searchPostButton]; */


    self.searchPostButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"SEARCH"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(searchPostButtonTapped:)];
    self.navigationItem.rightBarButtonItem = self.searchPostButton;
    
    self.categories = [[NSMutableArray alloc] init];

    tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissDatepicker)];
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
}

- (void)dismissDatepicker
{
    [self.endDateField resignFirstResponder];
    [self.startDateField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//TABLE VIEW SETUP

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==5||indexPath.row==6||indexPath.row==7||indexPath.row==3||indexPath.row==4)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            for(id item in self.categories) {
                if([item isEqual:cell.textLabel.text]) {
                    [self.categories removeObject:item];
                    NSLog(@"category Removed: %@", cell.textLabel.text);
                    break;
                }
            }
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.categories addObject:cell.textLabel.text];
            NSLog(@"category added: %@", cell.textLabel.text);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
 
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.row == 2){
        
        cell.textLabel.text = @"Select type of entry:";
        
     //   [tableView setEditing:YES animated:YES];
        
      //  [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
   /*     UIButton *medicineButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 20, 50, 15)];
        [medicineButton setImage:[UIImage imageNamed:@"AddEntryModalMedicineIcon.png"] forState:UIControlStateNormal];
        [medicineButton setTitle:NSLocalizedString(@"Medication", nil) forState:UIControlStateNormal];
        [medicineButton addTarget:self action:@selector(selectedOption:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell addSubview:medicineButton];
        
        UIButton *readingButton = [[UIButton alloc] initWithFrame:CGRectMake(65, 20, 200, 30)];
      //  [readingButton setImage:[UIImage imageNamed:@"AddEntryModalBloodIcon.png"] forState:UIControlStateNormal];
        [readingButton setTitle:NSLocalizedString(@"Reading", @"Blood glucose reading entry type") forState:UIControlStateNormal];
        [readingButton addTarget:self action:@selector(selectedOption:) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [cell addSubview:readingButton]; */
        
        
        
  /*      self.categoryField = [[UITextField alloc] initWithFrame:CGRectMake(65, 20, 200, 30)];
        self.categoryField.placeholder = @"Select Category";
        self.categoryField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.categoryField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.categoryField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell addSubview:self.categoryField]; */
    }
    if (indexPath.row == 3){
        
        [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];

        
        cell.textLabel.text = @"Medication";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.tintColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1] ;
        
        
     //   [tableView setEditing:YES animated:YES];
        
    }
    if (indexPath.row == 4){
        
        [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        cell.textLabel.text = @"Reading";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.tintColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1] ;
        
     //   [tableView setEditing:YES animated:YES];
        
    }
    if (indexPath.row == 5){
        
        [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        cell.textLabel.text = @"Food";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.tintColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1] ;
        
    //    [tableView setEditing:YES animated:YES];
        
    }
    if (indexPath.row == 6){
        
        [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        cell.textLabel.text = @"Activity";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.tintColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1] ;
        
     //   [tableView setEditing:YES animated:YES];
        
    }
    if (indexPath.row == 7){
        [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];

        
        cell.textLabel.text = @"Note";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.tintColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1] ;
        
     //   [tableView setEditing:YES animated:YES];
        
    }
    if (indexPath.row == 0){

        cell.textLabel.text = @"From: ";
  //      cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        self.startDateField = [[UITextField alloc] initWithFrame:CGRectMake(105, 13, 150, 30)];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        self.startDateField.text = [dateFormat stringFromDate:[NSDate date]];
        
     //   self.startDateField.placeholder = @"MM/DD/YYYY";
        self.startDateField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.startDateField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.startDateField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell addSubview:self.startDateField];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(updatestartDateField:)
             forControlEvents:UIControlEventValueChanged];
        [self.startDateField setInputView:datePicker];
   /*
        self.datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
        self.datePicker.datePickerMode=UIDatePickerModeDate;
        [self.startDateField setInputView:self.datePicker];
        [self.datePicker setDate:[NSDate date]];
        [self.datePicker addTarget:self action:@selector(updatestartDateField:) forControlEvents:UIControlEventValueChanged]; */
        
        
 /*        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
   //     [self.datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self.datePicker setDate:[NSDate date]];
        [self.datePicker addTarget:self action:@selector(updatestartDateField:) forControlEvents:UIControlEventValueChanged];
*/
   //     startDateField.inputView = self.datePicker;
    }
    if (indexPath.row == 1){
     //   [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
        
        cell.textLabel.text = @"To: ";
        
        self.endDateField = [[UITextField alloc] initWithFrame:CGRectMake(105, 13, 150, 30)];
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        self.endDateField.text = [dateFormat stringFromDate:[NSDate date]];
        
        self.endDateField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.endDateField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.endDateField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell addSubview:self.endDateField];
        
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker addTarget:self action:@selector(updateTextField:)
             forControlEvents:UIControlEventValueChanged];
        [self.endDateField setInputView:datePicker];
        

  /*      self.endDateField = [[UITextField alloc] initWithFrame:CGRectMake(65, 20, 200, 30)];
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

        endDateField.inputView = self.datePicker; */
    }
/*    if (indexPath.row == 8){
        
        self.searchPostButton = [[UIButton alloc] initWithFrame:CGRectMake(65,20,200,30)];
        [self.searchPostButton setBackgroundColor:[UIColor blackColor]];
        [self.searchPostButton addTarget:self action:@selector(searchPostButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.searchPostButton setTitle:@"Search Posts" forState:UIControlStateNormal];

        [cell addSubview:self.searchPostButton];
    } */
    return cell;
}

-(void)updateTextField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    self.endDateField.text = [dateFormat stringFromDate:sender.date];
}
-(void)updatestartDateField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    self.startDateField.text = [dateFormat stringFromDate:sender.date];
}

-(IBAction)searchPostButtonTapped:(id)sender{
    
    

    for(id cat in self.categories)
    {
        NSLog(@"ENTERING");
        NSLog(@"%@", cat);
    }

    // NSLog(@"Categories selected %@",selectedRowPath);
    NSUInteger *size = [self.categories count];
    NSLog(@"%lul", (unsigned long)size);
    
    if(![startDateField hasText] || ![endDateField hasText]){
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete entries" message:@"Please fill all the details" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [self.alertView show];
    }
    else if (!self.categories){
        
        NSLog(@"checking category count");
        self.alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete entries" message:@"Please select some entry type" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [self.alertView show];
    }
    else {
        NSLog(@"Entered else part");
        
        NSLog(@"Entered StartDate: %@", startDateField.text);
        NSLog(@"Entered EndDate: %@", endDateField.text);

        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy"];
        
        NSDate *startDate = [dateFormat dateFromString:startDateField.text];
        NSDate *endDate = [dateFormat dateFromString:endDateField.text];
        NSDate *today = [NSDate date];
        
        NSLog(@"after conversion StartDate: %@", startDate);
        NSLog(@"after conversion EndDate: %@", endDate);
        
        if(startDate>endDate){
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"Start Date should be older than End Date" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [self.alertView show];
        }
   /*     else if(endDate>today){
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"Cannot select future date" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [self.alertView show];
        }
        else if(startDate>today){
            self.alertView = [[UIAlertView alloc] initWithTitle:@"Invalid Date" message:@"Cannot select future date" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [self.alertView show];
        } */
        else{
            //set time to 00 hrs
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comps = [calendar components:unitFlags fromDate:startDate];
            comps.hour   = 00;
            comps.minute = 00;
            comps.second = 00;
            self.searchStartDate = [calendar dateFromComponents:comps];
            
            NSDateComponents *comps1 = [calendar components:unitFlags fromDate:endDate];
            comps1.hour   = 23;
            comps1.minute = 59;
            comps1.second = 59;
            self.searchEndDate = [calendar dateFromComponents:comps1];
            
            //Push view controller
            ShareViewController *vc = [[ShareViewController alloc] init];
            vc.searchCategory = self.categories;
            vc.searchStartDate = self.searchStartDate;
            vc.searchEndDate = self.searchEndDate;
            [[self navigationController] pushViewController:vc animated:YES];
            
        }
        
    }
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
