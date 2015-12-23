//
//  UAExportViewController.m
//  Diabetik
//
//  Created by Nial Giacomelli on 01/04/2013.
//  Copyright (c) 2013-2014 Nial Giacomelli
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <Dropbox/Dropbox.h>
#import "MBProgressHUD.h"

#import "UAExportViewController.h"
#import "UAAppDelegate.h"
#import "UAEventController.h"
#import "UAExportTooltipView.h"

#import "UAEvent.h"
#import "UAMedicine.h"
#import "UAActivity.h"
#import "UAMeal.h"
#import "UANote.h"
#import "UAReading.h"

#define kExportTypeDropbox  0
#define kExportTypeEmail    1
#define kExportTypeAirPrint 2

@interface UAExportViewController ()
{
    OrderedDictionary *reportData;
    NSMutableDictionary *selectedMonths;
    
    BOOL exportPDF, exportCSV;
    
    NSDateFormatter *dateFormatter, *longDateFormatter;
    NSDateFormatter *timeFormatter;
}
@property (nonatomic, strong) UAViewControllerMessageView *noReportsMessageView;

// Logic
- (NSArray *)fetchEventsFromDate:(NSDate *)fromDate
                          toDate:(NSDate *)toDate
                         withMOC:(NSManagedObjectContext *)moc;

@end

@implementation UAExportViewController

#pragma mark - Setup
- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = NSLocalizedString(@"Export", nil);
        
        exportPDF = YES;
        exportCSV = NO;
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        
        longDateFormatter = [[NSDateFormatter alloc] init];
        [longDateFormatter setDateStyle:NSDateFormatterMediumStyle];
        
        timeFormatter = [[NSDateFormatter alloc] init];
        [timeFormatter setTimeStyle:NSDateFormatterShortStyle];

        reportData = nil;
        selectedMonths = [[NSMutableDictionary alloc] init];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Export", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(performExport:)];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadViewData:nil];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:kHasSeenExportTooltip])
    {
        [self showTips];
    }
}
- (void)reloadViewData:(NSNotification *)note
{
    [super reloadViewData:note];
    
    reportData = [self fetchEvents];
    [self refreshView];
}
- (void)refreshView
{
    if(!self.noReportsMessageView)
    {
        self.noReportsMessageView = [UAViewControllerMessageView addToViewController:self
                                                                           withTitle:NSLocalizedString(@"No Reports", nil)
                                                                          andMessage:NSLocalizedString(@"You currently don't have any reports to export.", nil)];
    }
    
    if(!reportData)
    {
        self.noReportsMessageView.hidden = NO;
        self.tableView.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    else
    {
        self.noReportsMessageView.hidden = YES;
        self.tableView.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)performExport:(id)sender
{
    [[VKRSAppSoundPlayer sharedInstance] playSound:@"tap-significant"];
    
    NSInteger totalMonthsSelected = 0;
    for(NSString *month in [selectedMonths allKeys])
    {
        if([[selectedMonths objectForKey:month] boolValue])
        {
            totalMonthsSelected ++;
        }
    }
    
    if(exportPDF || exportCSV)
    {
        if(reportData && totalMonthsSelected)
        {
            UIActionSheet *actionSheet = nil;
            if ([UIPrintInteractionController isPrintingAvailable])
            {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"Dropbox", nil), NSLocalizedString(@"Email", nil), NSLocalizedString(@"AirPrint", nil), nil];
            }
            else
            {
                actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                          delegate:self
                                                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:NSLocalizedString(@"Dropbox", nil), NSLocalizedString(@"Email", nil), nil];
            }
            [actionSheet showInView:self.view];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                message:NSLocalizedString(@"You must select at least one month to export", nil)
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                            message:NSLocalizedString(@"You must select at least one format to export", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)triggerExport:(NSInteger)type
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSString *date = [longDateFormatter stringFromDate:[NSDate date]];
        
        NSData *csvData = [self generateCSVData];
        NSData *pdfData = [self generatePDFData];
        
        if(type == kExportTypeDropbox)
        {
            DBAccount *account = [[DBAccountManager sharedManager] linkedAccount];
            if(!account)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [[DBAccountManager sharedManager] linkFromController:self];
                });
            }
            else
            {
                if([[DBFilesystem sharedFilesystem] completedFirstSync])
                {
                    NSError *error = nil;
                    
                    // Generate our report data
                    if(exportCSV)
                    {
                        // Save our CSV
                        DBPath *newPath = [[DBPath root] childPath:[NSString stringWithFormat:@"exports/%@ Export.csv", date]];
                        DBFile *file = [[DBFilesystem sharedFilesystem] openFile:newPath error:nil];
                        if(!file)
                        {
                            file = [[DBFilesystem sharedFilesystem] createFile:newPath error:&error];
                        }
                        
                        if(file && !error)
                        {
                            [file writeData:csvData error:&error];
                            [file close];
                        }
                    }
                    
                    // Save our PDF
                    if(exportPDF)
                    {
                        DBPath *newPath = [[DBPath root] childPath:[NSString stringWithFormat:@"exports/%@ Export.pdf", date]];
                        DBFile *file = [[DBFilesystem sharedFilesystem] openFile:newPath error:nil];
                        if(!file)
                        {
                            file = [[DBFilesystem sharedFilesystem] createFile:newPath error:&error];
                        }
                        
                        if(file && !error)
                        {
                            [file writeData:pdfData error:&error];
                            [file close];
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        if(error)
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                                message:[NSString stringWithFormat:NSLocalizedString(@"It wasn't possible to export your files to Dropbox. The following error occurred: %@", nil), [error localizedDescription]]
                                                                               delegate:nil
                                                                      cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                                      otherButtonTitles:nil];
                            [alertView show];
                        }
                        else
                        {
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Export successful", nil)
                                                                                message:[NSString stringWithFormat:NSLocalizedString(@"Your files have been exported successfully", nil)]
                                                                               delegate:nil
                                                                      cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                                      otherButtonTitles:nil];
                            [alertView show];
                        }
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                            message:NSLocalizedString(@"Dropbox needs to finish syncing before it's possible to export files. Try again in a few minutes.", nil)
                                                                           delegate:nil
                                                                  cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                                  otherButtonTitles:nil];
                        [alertView show];
                    });
                }
            }
        }
        else if(type == kExportTypeEmail)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Here's your Diabetik data export, generated on %@.", nil), date];
                MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
                controller.mailComposeDelegate = self;
                [controller setSubject:[NSString stringWithFormat:NSLocalizedString(@"Diabetik Export - %@", nil), date]];
                [controller setMessageBody:message isHTML:NO];
                if(exportCSV)
                {
                    [controller addAttachmentData:csvData mimeType:@"text/csv" fileName:[NSString stringWithFormat:@"%@ Export.csv", date]];
                }
                if(exportPDF)
                {
                    [controller addAttachmentData:pdfData mimeType:@"text/pdf" fileName:[NSString stringWithFormat:@"%@ Export.pdf", date]];
                }
                
                if (controller)
                {
                    [self presentViewController:controller animated:YES completion:nil];
                }
            });
        }
        else if(type == kExportTypeAirPrint)
        {
            UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
            printController.delegate = self;
            
            NSMutableArray *printingItems = [NSMutableArray array];
            if(exportCSV) [printingItems addObject:csvData];
            if(exportPDF) [printingItems addObject:pdfData];
            
            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.jobName = @"Diabetik Export";
            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            printController.printInfo = printInfo;
            printController.showsPageRange = YES;
            printController.printingItems = printingItems;

            dispatch_async(dispatch_get_main_queue(), ^{
                [printController presentAnimated:YES completionHandler:^(UIPrintInteractionController *printInteractionController, BOOL completed, NSError *error) {

                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    if(!completed && error)
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                                            message:NSLocalizedString(@"There was an error while printing your report", nil)
                                                                           delegate:nil
                                                                  cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                                  otherButtonTitles:nil];
                        [alertView show];
                    }
                }];
            });
        }
    });
}
- (void)showTips
{
    UAAppDelegate *appDelegate = (UAAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *targetVC = appDelegate.viewController;
    
    UATooltipViewController *modalView = [[UATooltipViewController alloc] initWithParentVC:targetVC andDelegate:self];
    UAExportTooltipView *tooltipView = [[UAExportTooltipView alloc] initWithFrame:CGRectZero];
    [modalView setContentView:tooltipView];
    [modalView present];
}

#pragma mark - Logic
- (OrderedDictionary *)fetchEvents
{
    NSManagedObjectContext *moc = [[UACoreDataController sharedInstance] managedObjectContext];
    
    if(moc)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"UAEvent" inManagedObjectContext:moc];
        [request setEntity:entity];
        [request setSortDescriptors:@[sortDescriptor]];
        //[request setReturnsObjectsAsFaults:NO];
        
        // Execute the fetch.
        NSError *error = nil;
        NSArray *objects = [moc executeFetchRequest:request error:&error];
        
        if(!error)
        {
            NSDateFormatter *dateKeyFormatter = [[NSDateFormatter alloc] init];
            [dateKeyFormatter setDateFormat:@"MMM yyyy"];
            
            OrderedDictionary *dictionary = [[OrderedDictionary alloc] init];
            for(UAEvent *event in objects)
            {
                NSString *date = [dateKeyFormatter stringFromDate:event.timestamp];
                if(date)
                {
                    if(![dictionary objectForKey:date])
                    {
                        NSDate *startDate = [(NSDate *)event.timestamp dateAtStartOfMonth];
                        NSDate *endDate = [startDate dateAtEndOfMonth];

                        if(startDate && endDate)
                        {
                            [dictionary setObject:@{@"startDate": startDate, @"endDate": endDate} forKey:date];
                        }
                    }
                    
                    [selectedMonths setValue:[NSNumber numberWithBool:YES] forKey:date];
                }
                
                // Re-fault this object to conserve on memory
                [moc refreshObject:event mergeChanges:NO];
            }
            
            if([[dictionary allKeys] count])
            {
                return dictionary;
            }
        }
    }
    
    return nil;
}
- (NSArray *)fetchEventsFromDate:(NSDate *)fromDate
                          toDate:(NSDate *)toDate
                         withMOC:(NSManagedObjectContext *)moc
{
    __block NSArray *returnArray = nil;
    
    if(moc)
    {
        [moc performBlockAndWait:^{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp >= %@ && timestamp <= %@", fromDate, toDate];
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO];
            
            returnArray = [[UAEventController sharedInstance] fetchEventsWithPredicate:predicate
                                                                       sortDescriptors:@[sortDescriptor]
                                                                             inContext:moc];
        }];
    }
    
    return returnArray;
}
- (NSData *)generateCSVData
{
    __block NSData *returnData = nil;
    
    NSManagedObjectContext *moc = [[UACoreDataController sharedInstance] newPrivateContext];
    if(moc)
    {
        [moc performBlockAndWait:^{
            
            NSNumberFormatter *valueFormatter = [UAHelper standardNumberFormatter];
            NSNumberFormatter *glucoseFormatter = [UAHelper glucoseNumberFormatter];
            
            NSString *data = @"Month,Glucose Avg.,Total Activity,Total Grams,Glucose (Lowest),Glucose (Highest),Glucose (Avg. Deviation)";
            for(NSString *month in [reportData reverseKeyEnumerator])
            {
                @autoreleasepool {
                    NSDictionary *monthData = [reportData objectForKey:month];
                    if([[selectedMonths objectForKey:month] boolValue])
                    {
                        NSArray *events = [self fetchEventsFromDate:monthData[@"startDate"] toDate:monthData[@"endDate"] withMOC:moc];
                        if(events)
                        {
                            NSDictionary *monthStats = [[UAEventController sharedInstance] statisticsForEvents:events fromDate:monthData[@"startDate"] toDate:monthData[@"endDate"]];
                            
                            data = [data stringByAppendingFormat:@"\n\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\"", month, [glucoseFormatter stringFromNumber:[monthStats objectForKey:@"readings_avg"]], [valueFormatter stringFromNumber:[monthStats objectForKey:@"total_minutes"]], [valueFormatter stringFromNumber:[monthStats objectForKey:@"total_grams"]], [glucoseFormatter stringFromNumber:[monthStats objectForKey:@"lowest_reading"]], [glucoseFormatter stringFromNumber:[monthStats objectForKey:@"highest_reading"]], [glucoseFormatter stringFromNumber:[monthStats objectForKey:@"readings_deviation"]]];
                        }
                    }
                }
            }
            
            data = [data stringByAppendingFormat:@"\n\nDate,Time,Type,Info,Amount,Unit,Notes"];
            for(NSString *month in [reportData reverseKeyEnumerator])
            {
                @autoreleasepool {
                    if([[selectedMonths objectForKey:month] boolValue])
                    {
                        NSDictionary *monthData = [reportData objectForKey:month];
                        NSArray *events = [self fetchEventsFromDate:monthData[@"startDate"] toDate:monthData[@"endDate"] withMOC:moc];
                        if(events)
                        {
                            for(UAEvent *event in events)
                            {
                                NSString *notes = event.notes ? [event.notes escapedForCSV] : @"";
                                NSString *name = [event.name escapedForCSV];
                                
                                NSString *time = [timeFormatter stringFromDate:event.timestamp];
                                NSString *date = [dateFormatter stringFromDate:event.timestamp];
                                if([event isKindOfClass:[UANote class]])
                                {
                                    data = [data stringByAppendingFormat:@"\n\"%@\",%@,%@,%@,,,%@", date, time, [event humanReadableName], name, notes];
                                }
                                else if([event isKindOfClass:[UAMeal class]])
                                {
                                    UAMeal *meal = (UAMeal *)event;
                                    
                                    NSString *value = [valueFormatter stringFromNumber:meal.grams];
                                    data = [data stringByAppendingFormat:@"\n\"%@\",%@,%@,%@,\"%@\",%@,%@", date, time, [event humanReadableName], name, value, [NSLocalizedString(@"Grams", @"Unit of measurement") lowercaseString], notes];
                                }
                                else if([event isKindOfClass:[UAActivity class]])
                                {
                                    UAActivity *activity = (UAActivity *)event;
                                    
                                    NSString *activityTime = [UAHelper formatMinutes:[activity.minutes integerValue]];
                                    data = [data stringByAppendingFormat:@"\n\"%@\",%@,%@,%@,%@,%@,%@", date, time, [event humanReadableName], name, activityTime, NSLocalizedString(@"time", @"Unit of measurement"), notes];
                                }
                                else if([event isKindOfClass:[UAMedicine class]])
                                {
                                    UAMedicine *medicine = (UAMedicine *)event;
                                    
                                    NSString *value = [valueFormatter stringFromNumber:medicine.amount];
                                    NSString *unit = [[UAEventController sharedInstance] medicineTypeHR:[medicine.type integerValue]];
                                    data = [data stringByAppendingFormat:@"\n\"%@\",%@,%@,%@,\"%@\",%@,%@", date, time, [event humanReadableName], name, value, unit, notes];
                                }
                                else if([event isKindOfClass:[UAReading class]])
                                {
                                    UAReading *reading = (UAReading *)event;
                                    
                                    NSString *value = [valueFormatter stringFromNumber:reading.value];
                                    NSString *unit = ([UAHelper userBGUnit] == BGTrackingUnitMG) ? @"mg/dL" : @"mmoI/L";
                                    data = [data stringByAppendingFormat:@"\n\"%@\",%@,%@,%@,\"%@\",%@,%@", date, time, [event humanReadableName], name, value, unit, notes];
                                }
                                
                                // Re-fault this object to conserve on memory
                                [moc refreshObject:event mergeChanges:NO];
                            }
                        }
                    }
                }
            }
            
            returnData = [data dataUsingEncoding:NSUTF8StringEncoding];
        }];
    }
    
    return returnData;
}
- (NSData *)generatePDFData
{
    __block NSData *returnData = nil;
    
    NSManagedObjectContext *moc = [[UACoreDataController sharedInstance] newPrivateContext];
    if(moc)
    {
        [moc performBlockAndWait:^{
            
            NSNumberFormatter *valueFormatter = [UAHelper standardNumberFormatter];
            NSNumberFormatter *glucoseFormatter = [UAHelper glucoseNumberFormatter];
            
            UAPDFDocument *pdfDocument = [[UAPDFDocument alloc] init];
            [pdfDocument setDelegate:self];
            [pdfDocument drawText:[dateFormatter stringFromDate:[NSDate date]]
                           inRect:CGRectMake(pdfDocument.contentFrame.origin.x + pdfDocument.contentFrame.size.width - 100.0f, pdfDocument.contentFrame.origin.y, 100.0f, 16.0f)
                         withFont:[UAFont standardDemiBoldFontWithSize:12.0f]
                        alignment:NSTextAlignmentRight
                    lineBreakMode:NSLineBreakByClipping];
            
            [pdfDocument drawImage:[UIImage imageNamed:@"logo.png"] atPosition:pdfDocument.contentFrame.origin];
            
            [pdfDocument drawText:NSLocalizedString(@"Your Diabetic Record", nil) atPosition:CGPointMake(pdfDocument.contentFrame.origin.x, pdfDocument.currentY + 30.0f) withFont:[UAFont standardDemiBoldFontWithSize:16.0f]];
            
            // Monthly breakdown
            [pdfDocument drawText:@"Monthly Breakdown" atPosition:CGPointMake(pdfDocument.contentFrame.origin.x, pdfDocument.currentY + 15.0f) withFont:[UAFont standardMediumFontWithSize:14.0f]];
            
            CGFloat columnWidth = ((pdfDocument.contentFrame.size.width/pdfDocument.contentFrame.size.width)*100)/7.0f;
            NSArray *columns = @[
                @{@"title": @"Month", @"width": [NSNumber numberWithDouble:columnWidth]},
                @{@"title": @"Glucose Avg.", @"width": [NSNumber numberWithDouble:columnWidth]},
                @{@"title": @"Total Activity", @"width": [NSNumber numberWithDouble:columnWidth]},
                @{@"title": @"Total Grams", @"width": [NSNumber numberWithDouble:columnWidth]},
                @{@"title": @"Glucose (Lowest)", @"width": [NSNumber numberWithDouble:columnWidth]},
                @{@"title": @"Glucose (Highest)", @"width": [NSNumber numberWithDouble:columnWidth]},
                @{@"title": @"Glucose Deviation", @"width": [NSNumber numberWithDouble:columnWidth]}
            ];
            
            NSMutableArray *rows = [NSMutableArray array];
            for(NSString *month in [reportData reverseKeyEnumerator])
            {
                @autoreleasepool {
                    NSDictionary *monthData = [reportData objectForKey:month];
                    if([[selectedMonths objectForKey:month] boolValue])
                    {
                        NSArray *events = [self fetchEventsFromDate:monthData[@"startDate"] toDate:monthData[@"endDate"] withMOC:moc];
                        if(events)
                        {
                            NSDictionary *monthStats = [[UAEventController sharedInstance] statisticsForEvents:events fromDate:monthData[@"startDate"] toDate:monthData[@"endDate"]];
                            
                            [rows addObject:@[month, [glucoseFormatter stringFromNumber:[monthStats objectForKey:@"readings_avg"]], [valueFormatter stringFromNumber:[monthStats objectForKey:@"total_minutes"]], [valueFormatter stringFromNumber:[monthStats objectForKey:@"total_grams"]], [glucoseFormatter stringFromNumber:[monthStats objectForKey:@"lowest_reading"]], [glucoseFormatter stringFromNumber:[monthStats objectForKey:@"highest_reading"]], [glucoseFormatter stringFromNumber:[monthStats objectForKey:@"readings_deviation"]]]];
                        }
                    }
                }
            }

            [pdfDocument drawTableWithRows:rows
                                andColumns:columns
                                atPosition:CGPointMake(pdfDocument.contentFrame.origin.x, pdfDocument.currentY + 10.0f)
                                     width:pdfDocument.contentFrame.size.width
                                identifier:@"summary"];
            
            // Item entries
            [pdfDocument drawText:@"Itemised entries" atPosition:CGPointMake(pdfDocument.contentFrame.origin.x, pdfDocument.currentY + 25.0f) withFont:[UAFont standardMediumFontWithSize:14.0f]];
            
            columnWidth = ((pdfDocument.contentFrame.size.width/pdfDocument.contentFrame.size.width)*100)/5.0f;
            columns = @[
                        @{@"title": @"Date/Time", @"width": [NSNumber numberWithDouble:columnWidth]},
                        @{@"title": @"Type", @"width": [NSNumber numberWithDouble:columnWidth]},
                        @{@"title": @"Info", @"width": [NSNumber numberWithDouble:columnWidth]},
                        @{@"title": @"Amount", @"width": [NSNumber numberWithDouble:columnWidth]},
                        @{@"title": @"Notes", @"width": [NSNumber numberWithDouble:columnWidth]}
                        ];
            
            rows = [NSMutableArray array];
            for(NSString *month in [reportData reverseKeyEnumerator])
            {
                @autoreleasepool {
                    
                    if([[selectedMonths objectForKey:month] boolValue])
                    {
                        NSDictionary *monthData = [reportData objectForKey:month];
                    
                        NSArray *events = [self fetchEventsFromDate:monthData[@"startDate"] toDate:monthData[@"endDate"] withMOC:moc];
                        if(events)
                        {
                            for(UAEvent *event in events)
                            {
                                NSString *notes = event.notes ? event.notes : @"";
                                NSString *name = event.name;
                                
                                NSString *time = [timeFormatter stringFromDate:event.timestamp];
                                NSString *date = [dateFormatter stringFromDate:event.timestamp];
                                if([event isKindOfClass:[UANote class]])
                                {
                                    [rows addObject:@[[NSString stringWithFormat:@"%@\n%@", date, time], [event humanReadableName], name, @"", notes]];
                                }
                                else if([event isKindOfClass:[UAMeal class]])
                                {
                                    UAMeal *meal = (UAMeal *)event;
                                    
                                    NSString *value = [valueFormatter stringFromNumber:meal.grams];
                                    [rows addObject:@[[NSString stringWithFormat:@"%@\n%@", date, time], [event humanReadableName], name, value, notes]];
                                }
                                else if([event isKindOfClass:[UAActivity class]])
                                {
                                    UAActivity *activity = (UAActivity *)event;
                                    
                                    NSString *activityTime = [valueFormatter stringFromNumber:activity.minutes];
                                    [rows addObject:@[[NSString stringWithFormat:@"%@\n%@", date, time], [event humanReadableName], name, activityTime, notes]];
                                }
                                else if([event isKindOfClass:[UAMedicine class]])
                                {
                                    UAMedicine *medicine = (UAMedicine *)event;
                                    
                                    NSString *value = [valueFormatter stringFromNumber:medicine.amount];
                                    NSString *unit = [[UAEventController sharedInstance] medicineTypeHR:[medicine.type integerValue]];
                                    [rows addObject:@[[NSString stringWithFormat:@"%@\n%@", date, time], [event humanReadableName], name, [NSString stringWithFormat:@"%@ %@", value, unit], notes]];
                                }
                                else if([event isKindOfClass:[UAReading class]])
                                {
                                    UAReading *reading = (UAReading *)event;
                                    
                                    NSString *value = [valueFormatter stringFromNumber:reading.value];
                                    NSString *unit = ([UAHelper userBGUnit] == BGTrackingUnitMG) ? @"mg/dL" : @"mmoI/L";
                                    [rows addObject:@[[NSString stringWithFormat:@"%@\n%@", date, time], [event humanReadableName], name, [NSString stringWithFormat:@"%@ %@", value, unit], notes]];
                                }
                                
                                // Re-fault this object to conserve on memory
                                [moc refreshObject:event mergeChanges:NO];
                            }
                        }
                    }
                }
            }
            
            [pdfDocument drawTableWithRows:rows
                                andColumns:columns
                                atPosition:CGPointMake(pdfDocument.contentFrame.origin.x, pdfDocument.currentY + 10.0f)
                                     width:pdfDocument.contentFrame.size.width
                                identifier:@"itemised"];
            
            [pdfDocument close];
            
            returnData = pdfDocument.data;
        }];
    }
    
    return returnData;
}

#pragma mark - UAPDFDocumentDelegate methods
- (void)drawPDFTableHeaderInDocument:(UAPDFDocument *)document
                      withIdentifier:(NSString *)identifier
                             content:(id)content
                   contentAttributes:(NSDictionary *)contentAttributes
                         contentRect:(CGRect)contentRect
                            cellRect:(CGRect)cellRect
{
    [[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f] setFill];
    UIRectFill(cellRect);
    
    [[UIColor blackColor] setFill];
    [document drawText:(NSString *)content
                inRect:contentRect
              withFont:contentAttributes[UAPDFDocumentFontName]
             alignment:NSTextAlignmentLeft
         lineBreakMode:NSLineBreakByWordWrapping];
}
- (void)drawPDFTableCellInDocument:(UAPDFDocument *)document
                    withIdentifier:(NSString *)identifier
                           content:(id)content
                 contentAttributes:(NSDictionary *)contentAttributes
                       contentRect:(CGRect)contentRect
                          cellRect:(CGRect)cellRect
                      cellPosition:(CGPoint)cellPosition
{
    if((int)cellPosition.y%2)
    {
        [[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f] setFill];
        UIRectFill(cellRect);
    }
    
    [[UIColor blackColor] setFill];
    [document drawText:(NSString *)content
                inRect:contentRect
              withFont:contentAttributes[UAPDFDocumentFontName]
             alignment:(cellPosition.x == 0 || [identifier isEqualToString:@"itemised"] ? NSTextAlignmentLeft : NSTextAlignmentCenter)
         lineBreakMode:NSLineBreakByWordWrapping];
}
- (NSDictionary *)attributesForPDFCellInDocument:(UAPDFDocument *)document
                                  withIdentifier:(NSString *)identifier
                                        rowIndex:(NSInteger)rowIndex
                                     columnIndex:(NSInteger)columnIndex
{
    UIFont *font = [UAFont standardRegularFontWithSize:12.0f];
    if(rowIndex == 0)
    {
        font = [UAFont standardDemiBoldFontWithSize:12.0f];
    }
    
    return @{UAPDFDocumentFontName:font};
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [reportData count];
    }
    
    return 2;
}
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return NSLocalizedString(@"Months to export", nil);
    }
    else if(section == 1)
    {
        return NSLocalizedString(@"Formats to export", nil);
    }
    
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (UIView *)tableView:(UITableView *)aTableView viewForHeaderInSection:(NSInteger)section
{
    UAGenericTableHeaderView *header = [[UAGenericTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, aTableView.frame.size.width, 40.0f)];
    [header setText:[self tableView:aTableView titleForHeaderInSection:section]];
    return header;
}
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UAGenericTableViewCell *cell = (UAGenericTableViewCell *)[aTableView dequeueReusableCellWithIdentifier:@"UASettingCell"];
    if (cell == nil)
    {
        cell = [[UAGenericTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UASettingCell"];
    }
    
    if(indexPath.section == 0)
    {
        NSArray *keys = [reportData allKeys];
        NSString *date = [keys objectAtIndex:indexPath.row];
        
        cell.textLabel.text = date;
        
        if([[selectedMonths objectForKey:date] boolValue])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"PDF";
            cell.accessoryType = exportPDF ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
        else
        {
            cell.textLabel.text = @"CSV";
            cell.accessoryType = exportCSV ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

#pragma mar - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if(indexPath.section == 0)
    {
        NSArray *keys = [reportData allKeys];
        NSString *date = [keys objectAtIndex:indexPath.row];
        
        BOOL selected = [[selectedMonths valueForKey:date] boolValue];
        [selectedMonths setValue:[NSNumber numberWithBool:!selected] forKey:date];
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0) exportPDF = !exportPDF;
        if(indexPath.row == 1) exportCSV = !exportCSV;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex <= 2)
    {
        [self triggerExport:buttonIndex];
    }
}

#pragma mark - MFMailComposeViewControllerDelegate methods
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if(result == MFMailComposeResultSent)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email sent", nil)
                                                            message:NSLocalizedString(@"Your export email has been sent", @"A success message letting the user know that their data export has been successfully emailed to them")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    else if(result == MFMailComposeResultFailed)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Uh oh!", nil)
                                                            message:NSLocalizedString(@"Your export email could not be sent", @"An error message letting the user know that their data export could not be emailed to them")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Okay", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    if(result != MFMailComposeResultFailed)
    {
        [controller dismissViewControllerAnimated:YES completion:^{
            // STUB
        }];
    }
}

#pragma mark - UATooltipViewControllerDelegate methods
- (void)willDisplayModalView:(UATooltipViewController *)aModalController
{
    // STUB
}
- (void)didDismissModalView:(UATooltipViewController *)aModalController
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kHasSeenExportTooltip];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - UIPrintInteractionControllerDelegate methods
- (UIViewController *)printInteractionControllerParentViewController:(UIPrintInteractionController *)printInteractionController
{
    return self.navigationController;
}
- (void)printInteractionControllerDidDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
