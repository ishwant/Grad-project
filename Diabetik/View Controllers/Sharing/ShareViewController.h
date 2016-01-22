

#import <UIKit/UIKit.h>
#import "TESTEvent.h"

@interface ShareViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewObject;
@property (weak, nonatomic) UIBarButtonItem *postButton;

@property (nonatomic,retain) NSMutableArray *tableData;

@property (strong, nonatomic) NSString *searchCategory;
@property (strong, nonatomic) NSDate *searchStartDate;
@property (strong, nonatomic) NSDate *searchEndDate;

#pragma mark - Methods
- (void) retrieveData;
- (bool *) postData:(TESTEvent *)currEvent;
@end
