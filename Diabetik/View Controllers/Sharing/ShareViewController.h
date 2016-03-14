

#import <UIKit/UIKit.h>
#import "CoreEvent.h"
#import "detailTableViewController.h"


@interface ShareViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewObject;
@property (weak, nonatomic) UIBarButtonItem *postButton;

@property (strong, nonatomic) IBOutlet UIButton *checkBoxButton;

@property (nonatomic,retain) NSMutableArray *tableData;
@property (nonatomic,retain) NSMutableArray *checkedData;
@property (nonatomic,retain) NSMutableArray *selectedEvents;
@property (nonatomic,retain) CoreEvent *selectedEvent;


@property (strong, nonatomic) NSArray *searchCategory;
@property (strong, nonatomic) NSDate *searchStartDate;
@property (strong, nonatomic) NSDate *searchEndDate;

@property (strong, nonatomic) NSString *loggedInUserToken;

@property (strong, nonatomic) IBOutlet UITextField *messageField;

@property (strong, nonatomic) id btnData;

#pragma mark - Methods

- (void) retrieveMedicineData;
- (void) retrieveActivityData;
- (void) retrieveMealData;
- (void) retrieveReadingData;
- (void) retrieveNotesData;

@end


