

#import <UIKit/UIKit.h>
#import "CoreEvent.h"

@interface ShareViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewObject;
@property (weak, nonatomic) UIBarButtonItem *postButton;

@property (nonatomic,retain) NSMutableArray *tableData;

@property (strong, nonatomic) NSString *searchCategory;
@property (strong, nonatomic) NSDate *searchStartDate;
@property (strong, nonatomic) NSDate *searchEndDate;

@property (strong, nonatomic) IBOutlet UITextField *messageField;

#pragma mark - Methods
- (void) retrieveData;
- (void) retrieveMedicineData;
- (void) retrieveActivityData;
- (void) retrieveMealData;
- (void) retrieveReadingData;
- (void) retrieveNotesData;

- (bool *) postData:(CoreEvent *)currEvent;
@end
