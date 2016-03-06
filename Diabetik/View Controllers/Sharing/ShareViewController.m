
#import "ShareViewController.h"
#import "CoreEvent.h"
#import "UAMedicine.h"
#import "UAActivity.h"
#import "UAMeal.h"
#import "UAReading.h"
#import "UANote.h"
#import "EventDetailsTableViewController.h"

#import "FBEncryptorAES.h"

static NSString* const kBaseURL = @"http://localhost:8080";

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize tableData,tableViewObject, messageField, searchCategory, loggedInUserToken;

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
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
    self.tableViewObject.allowsMultipleSelection = YES;
    NSLog(@"ShareViewController loading");
    self.title = @"SHARE";
    
    tableData = [[NSMutableArray alloc] init];
    self.selectedEvents = [[NSMutableArray alloc] init];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"SEND"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(postButtonTapped:)];
    self.navigationItem.rightBarButtonItem = postButton;
    
    NSArray *userAccounts = [SSKeychain accountsForService:@"graduateProject"];
    loggedInUserToken = [SSKeychain passwordForService:@"graduateProject" account:[userAccounts objectAtIndex:0][kSSKeychainAccountKey]];
    
    for (id searchCat in searchCategory) {
        NSLog(@"%@", searchCat);
        
        if ([searchCat isEqualToString:@"Medication"]){
            [self retrieveMedicineData];
        }
        else if ([searchCat isEqualToString:@"Activity"]){
            [self retrieveActivityData];
        }
        else if ([searchCat isEqualToString:@"Food"]){
            [self retrieveMealData];
        }
        else if ([searchCat isEqualToString:@"Reading"]){
            [self retrieveReadingData];
        }
        else if ([searchCat isEqualToString:@"Note"]){
            [self retrieveNotesData];
        }
    }
    
//UNCHECK    [self retrieveData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma - markup TableView Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    CoreEvent * currentEvent = [tableData objectAtIndex:indexPath.row];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", currentEvent.eventName];
    cell.tintColor = [UIColor colorWithRed:(83/255.0) green:(145/255.0) blue:(198/255.0) alpha:1] ;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 12) {
        if (buttonIndex == 1) {

            messageField = [alertView textFieldAtIndex:0];
          //  messageField.placeholder = @"[Optional] Type message...";
            
            NSLog(@"message: %@", messageField.text);
        }
    }
}

-(IBAction)postButtonTapped:(id)sender{
    bool * checkPosted = false;
    NSArray *indexPathArray = [self.tableViewObject indexPathsForSelectedRows];
    if(indexPathArray == Nil){
        
      //  NSLog(@"%@", messageField.text);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert!" message:[NSString stringWithFormat:@"Select Data to Post"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
        
    }
    else{
        for(NSIndexPath *index in indexPathArray)
        {
            CoreEvent * currentEvent = [tableData objectAtIndex:index.row];
            [self.selectedEvents addObject:currentEvent];
        //    checkPosted = [self postData:currentEvent];
        }
     //   if(checkPosted){
            
            EventDetailsTableViewController *vc = [[EventDetailsTableViewController alloc] init];
            vc.selectedEvents = self.selectedEvents;
            [[self navigationController] pushViewController:vc animated:YES];

      /*      
       ShareViewController *vc = [[ShareViewController alloc] init];
       vc.searchCategory = self.categories;
       vc.searchStartDate = self.searchStartDate;
       vc.searchEndDate = self.searchEndDate;
       [[self navigationController] pushViewController:vc animated:YES];
       
        UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Alert"
                                      message:@"Shared successfully!! \n Want to send message? (Optional)"
                                      delegate:self
                                      cancelButtonTitle:@"Cancel"
                                      otherButtonTitles:@"Send Message", nil];
            
            [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
            alertView.tag = 12;
            [alertView textFieldAtIndex:0].frame = CGRectMake(25,25,200,200);
            messageField = [alertView textFieldAtIndex:0];
            [messageField setPlaceholder:@"[Optional] Type message here.."];
            //  messageField.frame = CGRectMake(100, 100, 100, 100);
            [messageField setBackgroundColor:[UIColor whiteColor]];
            [alertView show]; */
            
        /*    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SUCCESS!" message:[NSString stringWithFormat:@"Posts has been shared successfully!!"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show]; */
   //     }
    }
}

/*
- (bool *) postData:(CoreEvent *)currEvent {
    
    bool *posted = false;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[kBaseURL stringByAppendingPathComponent:@"/share"]]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    NSLog(@"Event name to Share: %@",currEvent.eventName);
    //build an info object and convert to json
    
    NSString *key = loggedInUserToken;
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
                        loggedInUserToken, @"UserToken",
                        encCategory, @"eventCategory",
                        encName, @"eventName",
                        currEvent.eventTimestamp, @"eventTimestamp",
                        currEvent.eventNotes, @"eventNotes",
                        currEvent.eventMedicineAmount, @"eventMedicineAmount",
                        encMedicineType, @"eventMedicineType",
                        currEvent.eventReadingValue, @"eventReadingValue",
                        currEvent.eventMealAmount, @"eventMealAmount",
                        currEvent.eventActivityTime, @"eventActivityTime",
                        nil];

    }
    else if ([currEvent.eventCategory isEqual:@"Reading"]){
        dataToShare = [NSDictionary dictionaryWithObjectsAndKeys:
                       loggedInUserToken, @"UserToken",
                       encCategory, @"eventCategory",
                       encName, @"eventName",
                       currEvent.eventTimestamp, @"eventTimestamp",
                       currEvent.eventNotes, @"eventNotes",
                       currEvent.eventMedicineAmount, @"eventMedicineAmount",
                       currEvent.eventMedicineType, @"eventMedicineType",
                       encReadingValue, @"eventReadingValue",
                       currEvent.eventMealAmount, @"eventMealAmount",
                       currEvent.eventActivityTime, @"eventActivityTime",
                       nil];
    }
    else{
        dataToShare = [NSDictionary dictionaryWithObjectsAndKeys:
                        loggedInUserToken, @"UserToken",
                        encCategory, @"eventCategory",
                        encName, @"eventName",
                        currEvent.eventTimestamp, @"eventTimestamp",
                        currEvent.eventNotes, @"eventNotes",
                        currEvent.eventMedicineAmount, @"eventMedicineAmount",
                        currEvent.eventMedicineType, @"eventMedicineType",
                        currEvent.eventReadingValue, @"eventReadingValue",
                        currEvent.eventMealAmount, @"eventMealAmount",
                        currEvent.eventActivityTime, @"eventActivityTime",
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
*/

- (void) retrieveMedicineData{
    
    NSManagedObjectContext *moc = [[UACoreDataController sharedInstance] managedObjectContext];
    if(moc)
    {
        [moc performBlock:^{
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UAMedicine" inManagedObjectContext:moc];
            [request setEntity:entity];
            
            NSTimeInterval secondsBetween = [self.searchEndDate timeIntervalSinceDate:self.searchStartDate];
            NSLog(@"Controller Start Date %@", self.searchStartDate);
            NSLog(@"Controller End Date %@", self.searchEndDate);
            int numberOfDays = secondsBetween / 86400;
            
            NSLog(@"There are %d days in between the two dates.", numberOfDays);
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"timestamp >= %@", self.searchStartDate];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"timestamp =< %@", self.searchEndDate];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
            [request setPredicate:predicate];
            
            // Execute the fetch.
            NSError *error = nil;
            NSMutableArray *objects = [NSMutableArray array];
            
            NSArray *results = [moc executeFetchRequest:request error:&error];
            if(results)
            {
                [objects addObjectsFromArray:results];
            }
            
            if (objects != nil && [objects count] > 0)
            {
                NSMutableArray *allEvents = [NSMutableArray array];
                
                for(UAMedicine *event in objects)
                {
                    [allEvents addObject:event];
                }
                
                if([allEvents count] > 0)
                {
                        //Create event object
                        
                        for (int i = 0; i < allEvents.count; i++){
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            
                            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                            [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
                            
                            NSString *eDate = [dateFormatter stringFromDate: [((UAMedicine *)[allEvents objectAtIndex:i]) timestamp] ];
                            NSNumber * eAmount = (NSNumber *)[[allEvents objectAtIndex:i] amount];
                            NSString * eNotes = [[allEvents objectAtIndex:i] notes];
                            NSString * eName = [[allEvents objectAtIndex:i] name];
                            
                            NSLog(@"%@", eName);
                            if(eNotes==nil){
                                eNotes = (NSString *)[NSNull null];
                            }

                            NSNumber *medType = [((UAMedicine *)[allEvents objectAtIndex:i]) type];
                            NSString *medicineType = NULL;
                            if ([medType  isEqual: @(0)]) {
                                medicineType = @"Units";
                            } else if([medType  isEqual: @(1)]) {
                                medicineType = @"MG";
                            } else if([medType  isEqual: @(2)]) {
                                medicineType = @"Pills";
                            } else if([medType  isEqual: @(3)]) {
                                medicineType = @"Puffs";
                            }
                            NSString *eCategory = [[NSString alloc] initWithFormat:@"Medication"];
                            
                            CoreEvent * myevent = [[CoreEvent alloc] initWitheventCategory:eCategory andeventName:eName andeventTimestamp:eDate andeventNotes:eNotes andeventMedicineAmount:eAmount andeventMedicineType: medicineType andeventReadingValue:(NSNumber *)[NSNull null] andeventMealAmount:(NSNumber *)[NSNull null] andeventActivityTime:(NSNumber *)[NSNull null]];

                            //Add our event object to our events array
                            [tableData addObject:myevent];
                        }
                        
                        //    return;
                    }

                    //  NSLog(@"Before reload");
                    [self tableData];
                    [self.tableViewObject reloadData];
                }

        }];
    }
    
    [self.tableViewObject reloadData];
}

- (void) retrieveActivityData{
    
    NSManagedObjectContext *moc = [[UACoreDataController sharedInstance] managedObjectContext];
    if(moc)
    {
        [moc performBlock:^{
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UAActivity" inManagedObjectContext:moc];
            [request setEntity:entity];
            
            NSTimeInterval secondsBetween = [self.searchEndDate timeIntervalSinceDate:self.searchStartDate];
            NSLog(@"Controller Start Date %@", self.searchStartDate);
            NSLog(@"Controller End Date %@", self.searchEndDate);
            int numberOfDays = secondsBetween / 86400;
            
            NSLog(@"There are %d days in between the two dates.", numberOfDays);
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"timestamp >= %@", self.searchStartDate];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"timestamp =< %@", self.searchEndDate];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
            [request setPredicate:predicate];

            // Execute the fetch.
            NSError *error = nil;
            NSMutableArray *objects = [NSMutableArray array];
            
            NSArray *results = [moc executeFetchRequest:request error:&error];
            if(results)
            {
                [objects addObjectsFromArray:results];
            }
            
            NSLog(@"%@", objects);
            if (objects != nil && [objects count] > 0)
            {
                NSMutableArray *allEvents = [NSMutableArray array];

                for(UAActivity *event in objects)
                {
                    [allEvents addObject:event];
                }
                    
                    if([allEvents count] > 0)
                    {
                        //Create event object
                        
                        for (int i = 0; i < allEvents.count; i++){
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                            
                            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                            [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
                            
                     //       NSString *eDate = (NSString *)[((UAActivity *)[allEvents objectAtIndex:i]) timestamp];
                            NSString *eDate = [dateFormatter stringFromDate: [((UAActivity *)[allEvents objectAtIndex:i]) timestamp] ];
                            NSNumber * eMinutes = (NSNumber *)[[allEvents objectAtIndex:i] minutes];
                            NSString * eNotes = [[allEvents objectAtIndex:i] notes];
                            NSString * eName = [[allEvents objectAtIndex:i] name];
                            
                            NSLog(@"%@", eName);
                            if(eNotes==nil){
                                eNotes = (NSString *)[NSNull null];
                            }
                            NSString *eCategory = [[NSString alloc] initWithFormat:@"Activity"];
                            CoreEvent * myevent = [[CoreEvent alloc] initWitheventCategory:eCategory andeventName:eName andeventTimestamp:eDate andeventNotes:eNotes andeventMedicineAmount:(NSNumber *)[NSNull null] andeventMedicineType: (NSString *)[NSNull null] andeventReadingValue:(NSNumber *)[NSNull null] andeventMealAmount:(NSNumber *)[NSNull null] andeventActivityTime:eMinutes];
                            
                            //Add our event object to our events array
                            [tableData addObject:myevent];
                        }
                        
                        //    return;
                    }

                    //  NSLog(@"Before reload");
                    [self tableData];
                    [self.tableViewObject reloadData];
                
            }
        }];
    }
    
    [self.tableViewObject reloadData];
}
- (void) retrieveMealData{
    
    NSManagedObjectContext *moc = [[UACoreDataController sharedInstance] managedObjectContext];
    if(moc)
    {
        [moc performBlock:^{
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UAMeal" inManagedObjectContext:moc];
            [request setEntity:entity];
            
            NSTimeInterval secondsBetween = [self.searchEndDate timeIntervalSinceDate:self.searchStartDate];
            NSLog(@"Controller Start Date %@", self.searchStartDate);
            NSLog(@"Controller End Date %@", self.searchEndDate);
            int numberOfDays = secondsBetween / 86400;
            
            NSLog(@"There are %d days in between the two dates.", numberOfDays);
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"timestamp >= %@", self.searchStartDate];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"timestamp =< %@", self.searchEndDate];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
            [request setPredicate:predicate];
            
            // Execute the fetch.
            NSError *error = nil;
            NSMutableArray *objects = [NSMutableArray array];
            
            NSArray *results = [moc executeFetchRequest:request error:&error];
            if(results)
            {
                [objects addObjectsFromArray:results];
            }
            
            NSLog(@"%@", objects);
            if (objects != nil && [objects count] > 0)
            {
                NSMutableArray *allEvents = [NSMutableArray array];
                
                for(UAMeal *event in objects)
                {
                    [allEvents addObject:event];
                }
                
                if([allEvents count] > 0)
                {
                    //Create event object
                    
                    for (int i = 0; i < allEvents.count; i++){
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        
                        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                        [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
                        
                    //    NSString *eDate = (NSString *)[((UAMeal *)[allEvents objectAtIndex:i]) timestamp];
                        NSString *eDate = [dateFormatter stringFromDate: [((UAMeal *)[allEvents objectAtIndex:i]) timestamp] ];
                        NSNumber * eAmount = (NSNumber *)[[allEvents objectAtIndex:i] grams];
                        NSString * eNotes = [[allEvents objectAtIndex:i] notes];
                        NSString * eName = [[allEvents objectAtIndex:i] name];
                        
                        NSLog(@"%@", eName);
                        if(eNotes==nil){
                            eNotes = (NSString *)[NSNull null];
                        }
                        NSString *eCategory = [[NSString alloc] initWithFormat:@"Food"];
                        CoreEvent * myevent = [[CoreEvent alloc] initWitheventCategory:eCategory andeventName:eName andeventTimestamp:eDate andeventNotes:eNotes andeventMedicineAmount:(NSNumber *)[NSNull null] andeventMedicineType: (NSString *)[NSNull null] andeventReadingValue:(NSNumber *)[NSNull null] andeventMealAmount:eAmount andeventActivityTime:(NSNumber *)[NSNull null]];
                        
                        //Add our event object to our events array
                        [tableData addObject:myevent];
                    }
                    
                    //    return;
                }
                
                //  NSLog(@"Before reload");
                [self tableData];
                [self.tableViewObject reloadData];
                
            }
        }];
    }
    
    [self.tableViewObject reloadData];
}
- (void) retrieveReadingData{
    
    NSManagedObjectContext *moc = [[UACoreDataController sharedInstance] managedObjectContext];
    if(moc)
    {
        [moc performBlock:^{
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UAReading" inManagedObjectContext:moc];
            [request setEntity:entity];
            
            NSTimeInterval secondsBetween = [self.searchEndDate timeIntervalSinceDate:self.searchStartDate];
            NSLog(@"Controller Start Date %@", self.searchStartDate);
            NSLog(@"Controller End Date %@", self.searchEndDate);
            int numberOfDays = secondsBetween / 86400;
            
            NSLog(@"There are %d days in between the two dates.", numberOfDays);
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"timestamp >= %@", self.searchStartDate];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"timestamp =< %@", self.searchEndDate];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
            [request setPredicate:predicate];
            
            // Execute the fetch.
            NSError *error = nil;
            NSMutableArray *objects = [NSMutableArray array];
            
            NSArray *results = [moc executeFetchRequest:request error:&error];
            if(results)
            {
                [objects addObjectsFromArray:results];
            }
            
            NSLog(@"%@", objects);
            if (objects != nil && [objects count] > 0)
            {
                NSMutableArray *allEvents = [NSMutableArray array];
                
                for(UAReading *event in objects)
                {
                    [allEvents addObject:event];
                }
                
                if([allEvents count] > 0)
                {
                    //Create event object
                    
                    for (int i = 0; i < allEvents.count; i++){
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        
                        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                        [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
                        
                    //    NSString *eDate = (NSString *)[((UAReading *)[allEvents objectAtIndex:i]) timestamp];
                        NSString *eDate = [dateFormatter stringFromDate: [((UAReading *)[allEvents objectAtIndex:i]) timestamp] ];
                        NSNumber * eReading = (NSNumber *)[[allEvents objectAtIndex:i] mgValue];
                        NSString * eNotes = [[allEvents objectAtIndex:i] notes];
                        NSString * eName = [[allEvents objectAtIndex:i] name];
                        
                        NSLog(@"%@", eName);
                        if(eNotes==nil){
                            eNotes = (NSString *)[NSNull null];
                        }
                        NSString *eCategory = [[NSString alloc] initWithFormat:@"Reading"];
                        CoreEvent * myevent = [[CoreEvent alloc] initWitheventCategory:eCategory andeventName:eName andeventTimestamp:eDate andeventNotes:eNotes andeventMedicineAmount:(NSNumber *)[NSNull null] andeventMedicineType: (NSString *)[NSNull null] andeventReadingValue:eReading andeventMealAmount:(NSNumber *)[NSNull null] andeventActivityTime:(NSNumber *)[NSNull null]];
                        
                        //Add our event object to our events array
                        [tableData addObject:myevent];
                    }
                    
                    //    return;
                }
                
                //  NSLog(@"Before reload");
                [self tableData];
                [self.tableViewObject reloadData];
                
            }
        }];
    }
    
    [self.tableViewObject reloadData];
}
- (void) retrieveNotesData{
    
    NSManagedObjectContext *moc = [[UACoreDataController sharedInstance] managedObjectContext];
    if(moc)
    {
        [moc performBlock:^{
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"UANote" inManagedObjectContext:moc];
            [request setEntity:entity];
            
            NSTimeInterval secondsBetween = [self.searchEndDate timeIntervalSinceDate:self.searchStartDate];
            NSLog(@"Controller Start Date %@", self.searchStartDate);
            NSLog(@"Controller End Date %@", self.searchEndDate);
            int numberOfDays = secondsBetween / 86400;
            
            NSLog(@"There are %d days in between the two dates.", numberOfDays);
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"timestamp >= %@", self.searchStartDate];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"timestamp =< %@", self.searchEndDate];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
            [request setPredicate:predicate];
            
            // Execute the fetch.
            NSError *error = nil;
            NSMutableArray *objects = [NSMutableArray array];
            
            NSArray *results = [moc executeFetchRequest:request error:&error];
            if(results)
            {
                [objects addObjectsFromArray:results];
            }
            
            NSLog(@"%@", objects);
            if (objects != nil && [objects count] > 0)
            {
                NSMutableArray *allEvents = [NSMutableArray array];
                
                for(UANote *event in objects)
                {
                    [allEvents addObject:event];
                }
                
                if([allEvents count] > 0)
                {
                    //Create event object
                    
                    for (int i = 0; i < allEvents.count; i++){
                        
                        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                        
                        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                        [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
                        
                     //   NSString *eDate = (NSString *)[((UANote *)[allEvents objectAtIndex:i]) timestamp];
                        NSString *eDate = [dateFormatter stringFromDate: [((UANote *)[allEvents objectAtIndex:i]) timestamp] ];
                        NSString * eNotes = [[allEvents objectAtIndex:i] notes];
                        NSString * eName = [[allEvents objectAtIndex:i] name];
                        
                        NSLog(@"%@", eName);
                        if(eNotes==nil){
                            eNotes = (NSString *)[NSNull null];
                        }
                        NSString *eCategory = [[NSString alloc] initWithFormat:@"Note"];
                        CoreEvent * myevent = [[CoreEvent alloc] initWitheventCategory:eCategory andeventName:eName andeventTimestamp:eDate andeventNotes:eNotes andeventMedicineAmount:(NSNumber *)[NSNull null] andeventMedicineType: (NSString *)[NSNull null] andeventReadingValue:(NSNumber *)[NSNull null] andeventMealAmount:(NSNumber *)[NSNull null] andeventActivityTime:(NSNumber *)[NSNull null]];
                        
                        //Add our event object to our events array
                        [tableData addObject:myevent];
                    }
                    
                    //    return;
                }
                
                //  NSLog(@"Before reload");
                [self tableData];
                [self.tableViewObject reloadData];
                
            }
        }];
    }
    
    [self.tableViewObject reloadData];
}


@end
