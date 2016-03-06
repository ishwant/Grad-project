//
//  EventDetailsTableViewController.m
//  Diabetik
//
//  Created by project on 3/5/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "EventDetailsTableViewController.h"
#import "FBEncryptorAES.h"
#import "CoreEvent.h"

static NSString* const kBaseURL = @"http://localhost:8080";

@interface EventDetailsTableViewController ()

@end

@implementation EventDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.selectedEvents);

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    NSLog(@"EventDetailsTableViewController loading");
    self.title = @"Details";
    
 //   self.selectedEvents = [[NSMutableArray alloc] init];
    self.selectedDetails = [[NSMutableArray alloc] init];
    self.sendButton = [[UIBarButtonItem alloc]
                             initWithTitle:@"Send"
                             style:UIBarButtonItemStyleBordered
                             target:self
                             action:@selector(sendButtonTapped:)];
    self.navigationItem.rightBarButtonItem = self.sendButton;

    self.details = [NSArray arrayWithObjects:@"Select details..",
                                             @"Fasting",
                                             @"Pre-Prandial",
                                             @"Post-Prandial",
                                             @"Pre-Exercise",
                                             @"Post-Exercise",
                                             nil];
    NSArray *userAccounts = [SSKeychain accountsForService:@"graduateProject"];
    self.loggedInUserToken = [SSKeychain passwordForService:@"graduateProject" account:[userAccounts objectAtIndex:0][kSSKeychainAccountKey]];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return ([self.details count]+1);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"eventTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    // Configure the cell...
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if (indexPath.row == 6){
        
        self.textMessageField = [[UITextField alloc] initWithFrame:CGRectMake(65, 17, 200, 30)];
        self.textMessageField.placeholder = @"Type message here.... ";
        self.textMessageField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.textMessageField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.textMessageField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell addSubview:self.textMessageField];
    }
    else{
        cell.textLabel.text = [self.details objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1||indexPath.row==2||indexPath.row==3||indexPath.row==4||indexPath.row==5)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            for(id item in self.selectedDetails) {
                if([item isEqual:cell.textLabel.text]) {
                    [self.selectedDetails removeObject:item];
                    NSLog(@"detail Removed: %@", cell.textLabel.text);
                    break;
                }
            }        }
        else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectedDetails addObject:cell.textLabel.text];
            NSLog(@"category added: %@", cell.textLabel.text);
        }
    }
}
-(IBAction)sendButtonTapped:(id)sender{
    bool * checkPosted = false;
    NSLog(@"sendButtonTapped");
    NSLog(@"%@", self.selectedDetails);
    if(self.selectedDetails){
        self.selectedDetailsString = [self.selectedDetails componentsJoinedByString:@","];
    }
    else{
        self.selectedDetailsString = (NSString *)[NSNull null];
    }
    NSLog(@"selectedDetailsString: %@", self.selectedDetailsString);
    for(CoreEvent *currEvent in self.selectedEvents){
        NSLog(@"Entering the iteration");
        checkPosted = [self postData:currEvent];
    }
    if(checkPosted){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert!" message:[NSString stringWithFormat:@"Shared successfully"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}

- (bool *) postData:(CoreEvent *)currEvent {
    
    bool *posted = false;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[kBaseURL stringByAppendingPathComponent:@"/share"]]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    NSLog(@"Event name to Share: %@",currEvent.eventName);
    //build an info object and convert to json
    
    NSString *key = self.loggedInUserToken;
    NSString *encCategory, *encName, *encMedicineType, *encReadingValue;
    
    if(currEvent.eventCategory){
        encCategory = [FBEncryptorAES encryptBase64String:currEvent.eventCategory
                                                keyString:key
                                            separateLines:NO];
        if([currEvent.eventCategory isEqual:@"Medication"]){
            encMedicineType = [FBEncryptorAES encryptBase64String:currEvent.eventMedicineType
                                                        keyString:key
                                                    separateLines:NO];
        }
        if([currEvent.eventCategory isEqual:@"Reading"]){
            NSString *value = [currEvent.eventReadingValue stringValue];
            encReadingValue = [FBEncryptorAES encryptBase64String:value
                                                        keyString:key
                                                    separateLines:NO];
            NSLog(@"%@", encReadingValue);
        }
    }
    if(currEvent.eventName){
        
        encName = [FBEncryptorAES encryptBase64String:currEvent.eventName
                                            keyString:key
                                        separateLines:NO];
    }
    
    NSDictionary *dataToShare;
    if([currEvent.eventCategory isEqual:@"Medication"]){
        dataToShare = [NSDictionary dictionaryWithObjectsAndKeys:
                       self.loggedInUserToken, @"UserToken",
                       encCategory, @"eventCategory",
                       encName, @"eventName",
                       currEvent.eventTimestamp, @"eventTimestamp",
                       currEvent.eventNotes, @"eventNotes",
                       currEvent.eventMedicineAmount, @"eventMedicineAmount",
                       encMedicineType, @"eventMedicineType",
                       currEvent.eventReadingValue, @"eventReadingValue",
                       currEvent.eventMealAmount, @"eventMealAmount",
                       currEvent.eventActivityTime, @"eventActivityTime",
                       self.textMessageField.text, @"eventMessage",
                       self.selectedDetailsString, @"eventDetails",
                       nil];
        
    }
    else if ([currEvent.eventCategory isEqual:@"Reading"]){
        dataToShare = [NSDictionary dictionaryWithObjectsAndKeys:
                       self.loggedInUserToken, @"UserToken",
                       encCategory, @"eventCategory",
                       encName, @"eventName",
                       currEvent.eventTimestamp, @"eventTimestamp",
                       currEvent.eventNotes, @"eventNotes",
                       currEvent.eventMedicineAmount, @"eventMedicineAmount",
                       currEvent.eventMedicineType, @"eventMedicineType",
                       encReadingValue, @"eventReadingValue",
                       currEvent.eventMealAmount, @"eventMealAmount",
                       currEvent.eventActivityTime, @"eventActivityTime",
                       self.textMessageField.text, @"eventMessage",
                       self.selectedDetailsString, @"eventDetails",
                       nil];
    }
    else{
        dataToShare = [NSDictionary dictionaryWithObjectsAndKeys:
                       self.loggedInUserToken, @"UserToken",
                       encCategory, @"eventCategory",
                       encName, @"eventName",
                       currEvent.eventTimestamp, @"eventTimestamp",
                       currEvent.eventNotes, @"eventNotes",
                       currEvent.eventMedicineAmount, @"eventMedicineAmount",
                       currEvent.eventMedicineType, @"eventMedicineType",
                       currEvent.eventReadingValue, @"eventReadingValue",
                       currEvent.eventMealAmount, @"eventMealAmount",
                       currEvent.eventActivityTime, @"eventActivityTime",
                       self.textMessageField.text, @"eventMessage",
                       self.selectedDetailsString, @"eventDetails",
                       nil];
    }
    
    
    //convert object to data
    NSLog(@"%@", dataToShare);
    
    if([NSJSONSerialization isValidJSONObject:dataToShare]){
        
        NSLog(@"YES, CAN CONVERT ");
        
        NSError *error;
        
        NSData* json_to_send = [NSJSONSerialization dataWithJSONObject: dataToShare options:NSJSONWritingPrettyPrinted error: &error];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[json_to_send length]] forHTTPHeaderField:@"Content-length"];
        request.HTTPBody = json_to_send;
        
        NSError *requestError = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&requestError];
        
        NSDictionary *jsonResponseData = [NSJSONSerialization
                                          JSONObjectWithData:responseData
                                          options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"%@",jsonResponseData);
        if(error != NULL){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connectivity error" message:@"Check network connection, Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            [alert show];
        }
        else {
            NSLog(@"Connection for post is established");
            
            if([[jsonResponseData  objectForKey:@"status"]  isEqualToString: @"SUCCESS"]){
                posted = TRUE;
                
            }
            else if([[jsonResponseData objectForKey:@"status"] isEqualToString:@"FAIL"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid User" message:@"The user name is invalid, Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        
    } else{
        NSLog(@"NO, CAN'T CONVERT ");
    }
    return posted;
}
@end
