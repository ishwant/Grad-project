
#import "ShareViewController.h"
#import "TESTEvent.h"
#import "UAMedicine.h"

static NSString* const kBaseURL = @"http://localhost:8080";

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize tableData,tableViewObject;

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
    self.tableViewObject.allowsMultipleSelection = YES;
    NSLog(@"ShareViewController loading");
    self.title = @"SHARE";
 //   tableData = [[NSMutableArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven",@"Eight",@"Nine",@"Ten",nil];
    tableData = [[NSMutableArray alloc] init];
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"POST"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(postButtonTapped:)];
    self.navigationItem.rightBarButtonItem = postButton;
    //[postButton release];
    
    
    [self retrieveData];
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
    
    TESTEvent * currentEvent = [tableData objectAtIndex:indexPath.row];
    
  //  [self.labelMsg stringByAppendingString: @"\nStep 1 Complete..."];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ | %@: %@", currentEvent.eventName , @"Amount" , currentEvent.eventAmount];
//    cell.textLabel.text = currentEvent.eventName;
 //   [cell.textLabel.text stringByAppendingString:@"\n Date "];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TESTEvent *curr = [tableData objectAtIndex:indexPath.row];
//    NSString * date = curr.eventDate;
    
 //   NSMutableString * amount = curr.eventAmount;
//    [date stringByAppendingString:amount];
 //   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Details!" message:[NSString stringWithFormat:@"Selected Value Details %@",date] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
  //  [alertView show];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryCheckmark){
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:none];
    //    [tableView selectRowAtIndexPath:indexPath animated:YES];
    }
}

-(IBAction)postButtonTapped:(id)sender{
    bool * checkPosted = false;
    NSArray *indexPathArray = [self.tableViewObject indexPathsForSelectedRows];
    if(indexPathArray == Nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert!" message:[NSString stringWithFormat:@"Select Data to Post"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertView show];
    }
    else{
        for(NSIndexPath *index in indexPathArray)
        {
            TESTEvent * currentEvent = [tableData objectAtIndex:index.row];
            checkPosted = [self postData:currentEvent];
        }
        if(checkPosted){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SUCCESS!" message:[NSString stringWithFormat:@"Posts has been shared successfully!!"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertView show];
        }
    }
}

- (void) retrieveData
{
    //   NSURL * url = [NSURL URLWithString:getDataURL];
    //   NSData * data = [NSData dataWithContentsOfURL:url];
    //==========================================================================================
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
            // Fetch all medication inputs over the past 15 days
        //    NSDate *timestamp = [[[NSDate date] dateAtStartOfDay] dateBySubtractingDays:30];
         //   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp >= %@", timestamp];
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"timestamp >= %@", self.searchStartDate];
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"timestamp =< %@", self.searchEndDate];
            NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate1, predicate2]];
            [request setPredicate:predicate];
            
            NSInteger hourInterval = 3;
            NSInteger numberOfSegments = 24/(hourInterval*2);
            
            // Execute the fetch.
            NSError *error = nil;
            NSMutableArray *objects = [NSMutableArray array];
            NSArray *results = [moc executeFetchRequest:request error:&error];
            if(results)
            {
                [objects addObjectsFromArray:results];
            }
            
            //   NSLog(@"%@", results);
            
            if (objects != nil && [objects count] > 0)
            {
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *currentComponents = [gregorianCalendar components:NSCalendarUnitHour fromDate:[NSDate date]];
                //     NSInteger currentHour = [currentComponents hour];
                
                // Create an event array index for each medicine 'type'
                NSMutableArray *previousEvents = [NSMutableArray array];
                //  NSMutableArray *todaysEvents = [NSMutableArray array];
                for(NSInteger i = 0; i < numberOfSegments; i++)
                {
                    [previousEvents addObject:[NSMutableArray array]];
                    //   [todaysEvents addObject:[NSMutableArray array]];
                }
                
                // Iterate over all medicine events that have taken place over the past 15 days
                for(UAMedicine *event in objects)
                {
                    //        NSDateComponents *eventComponents = [gregorianCalendar components:NSCalendarUnitHour fromDate:[event timestamp]];
                    //   NSInteger eventHour = [eventComponents hour];
                    
                    //==Add
                    NSMutableArray *existingEvents = [previousEvents objectAtIndex:[[event type] integerValue]];
                    [existingEvents addObject:event];
                    [previousEvents replaceObjectAtIndex:[[event type] integerValue] withObject:existingEvents];
                    
                    // If this event occurred today, remove it from the rest of the group
                    /*      if([[event timestamp] isEqualToDateIgnoringTime:[NSDate date]])
                     {
                     NSMutableArray *existingEvents = [todaysEvents objectAtIndex:[[event type] integerValue]];
                     [existingEvents addObject:event];
                     //   [todaysEvents replaceObjectAtIndex:[[event type] integerValue] withObject:existingEvents];
                     }
                     else
                     {
                     // Did this event happen within 3 hours (irrespective of date) from the current time?
                     if(labs(eventHour-currentHour) <= numberOfSegments-1)
                     {
                     NSMutableArray *existingEvents = [previousEvents objectAtIndex:[[event type] integerValue]];
                     [existingEvents addObject:event];
                     //   [previousEvents replaceObjectAtIndex:[[event type] integerValue] withObject:existingEvents];
                     }
                     } */
                }
                
                // Loop through today's events and try to determine what has already been entered
                /*     for(NSInteger i = 0; i < numberOfSegments; i++)
                 {
                 NSMutableArray *events = [todaysEvents objectAtIndex:i];
                 if([events count])
                 {
                 // Loop through all of the events of this type that occurred today
                 NSMutableArray *pEvents = [previousEvents objectAtIndex:i];
                 for(UAMedicine *event in events)
                 {
                 // Loop through previous events of this type
                 for(UAMedicine *pEvent in [pEvents copy])
                 {
                 // Determine whether this previous event is similar to the medicine taken earlier today
                 // If it is, remove it from consideration
                 NSString *eventDesc = [[event name] lowercaseString];
                 NSString *pEventDesc = [[pEvent name] lowercaseString];
                 if([eventDesc levenshteinDistanceToString:pEventDesc] <= 3)
                 {
                 NSDateComponents *eventComponents = [gregorianCalendar components:NSCalendarUnitHour fromDate:[event timestamp]];
                 NSInteger eventHour = [eventComponents hour];
                 
                 // Remove any medication taken within 3 hours of this date/time
                 if(fabs(eventHour-currentHour) <= numberOfSegments-1)
                 {
                 [pEvents removeObject:pEvent];
                 }
                 }
                 }
                 }
                 [previousEvents replaceObjectAtIndex:i withObject:pEvents];
                 }
                 } */
                
                //     NSLog(@"%lu", (unsigned long)previousEvents.count);
                //     NSLog(@"previous event count");
                //  NSLog(@"%lu", (unsigned long)todaysEvents.count);
                //  NSLog(@"Today's event count");
                
                NSMutableArray *sortedEvents = [NSMutableArray arrayWithArray:[previousEvents sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                    NSNumber *first = [NSNumber numberWithInteger:[a count]];
                    NSNumber *second = [NSNumber numberWithInteger:[b count]];
                    return [first compare:second];
                }]];
                /*     NSMutableArray *sortedTodayEvents = [NSMutableArray arrayWithArray:[todaysEvents sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                 NSNumber *first = [NSNumber numberWithInteger:[a count]];
                 NSNumber *second = [NSNumber numberWithInteger:[b count]];
                 return [first compare:second];
                 }]]; */
                
                //    NSLog(@"PRINTING TEST");
                //    NSLog(@"%@", previousEvents);
                for(NSInteger i = numberOfSegments-1; i >= 0; i--)
                {
                    NSMutableArray *events = [sortedEvents objectAtIndex:i];
                    
                    //   NSLog(@"%lu", (unsigned long)sortedEvents.count);
                    //  NSLog(@"sortedevents event count");
                    
                    // Only choose an event if there's more than 1 instance of it (experimental)
                    if([events count] > 1)
                    {
                        // successBlock((UAMedicine *)[events objectAtIndex:0]);
                        //      NSLog(@"%@", [[events objectAtIndex:0] name]);
                        //      NSLog(@"PRINTING TEST");
                          NSLog(@"%@", sortedEvents);
                        //   NSLog(@"PRINTING TEST TODAY");
                        //    NSLog(@"%@", todaysEvents);
                        
                        
                        //Create event object
                        
                        for (int i = 0; i < events.count; i++){
                            
                            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

                            [dateFormatter setDateStyle:NSDateFormatterShortStyle];
                            [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];

                            NSString *eDate = [dateFormatter stringFromDate:[[events objectAtIndex:i] createdTimestamp]];
                            
                          //  NSString * eDate = (NSString *)[[events objectAtIndex:i] createdTimestamp];
                            NSString * eAmount = (NSString *)[[events objectAtIndex:i] amount];
                            NSString * eNotes = [[events objectAtIndex:i] notes];
                            NSString * eName = [[events objectAtIndex:i] name];
                            
                            NSLog(@"%@", eName);
                            //      NSLog(@"%@", eDate);
                            //     NSLog(@"%@", eAmount);
                            //      NSLog(@"%@", eNotes);
                            if(eNotes==nil){
                                eNotes = (NSString *)[NSNull null];
                            }
                            
                            TESTEvent * myevent = [[TESTEvent alloc]initWitheventName:eName andeventAmount:eAmount andeventDate:eDate andeventNotes:eNotes];
                            
                            //Add our event object to our events array
                            [tableData addObject:myevent];
                            //  NSLog(@"%@", myevent.eventName);
                        }
                        
                        //    return;
                    }
                    else
                    {
                        // Uh oh, better get out of here
                        break;
                    }
                    //  NSLog(@"Before reload");
                    [self tableData];
                    [self.tableViewObject reloadData];
                }
            }
        }];
    }
    
    
    //==========================================================================================
    
    /*    json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
     
     //Set up our events array
     eventsArray = [[NSMutableArray alloc]init];
     
     for (int i = 0; i < json.count; i++)
     {
     //Create event object
     NSString * eName = [[json objectAtIndex:i] objectForKey:@"eventName"];
     NSString * eDate = [[json objectAtIndex:i] objectForKey:@"eventDate"];
     NSString * eAmount = [[json objectAtIndex:i] objectForKey:@"eventAmount"];
     NSString * eNotes = [[json objectAtIndex:i] objectForKey:@"eventNotes"];
     
     
     TESTEvent * myevent = [[TESTEvent alloc]initWitheventName:eName andeventAmount:eAmount andeventDate:eDate andeventNotes:eNotes];
     
     //Add our event object to our events array
     [eventsArray addObject:myevent];
     }
     */
    //   NSLog(@"reaching");
    //   NSLog(@"%@", eventsArray);
    
    [self.tableViewObject reloadData];
    
    
}

- (bool *) postData:(TESTEvent *)currEvent {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[kBaseURL stringByAppendingPathComponent:@"/share"]]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    NSLog(@"Event name to Share: %@",currEvent.eventName);
    //build an info object and convert to json
    NSDictionary *dataToShare = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Medicine", @"eventCategory",
                          currEvent.eventName, @"eventName",
                          currEvent.eventAmount, @"eventAmount",
                          currEvent.eventDate, @"eventDate",
                          currEvent.eventNotes, @"eventNotes",
                          nil];
    
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
                bool *posted = TRUE;
                return posted;
            }
            else if([[jsonResponseData objectForKey:@"status"] isEqualToString:@"FAIL"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid User" message:@"The user name is invalid, Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        
    } else{
        NSLog(@"NO, CAN'T CONVERT ");
    }
    
}



@end
