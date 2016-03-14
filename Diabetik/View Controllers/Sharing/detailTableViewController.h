//
//  detailTableViewController.h
//  Diabetik
//
//  Created by project on 3/10/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewController.h"


@protocol getDetailsDelegate <NSObject>

-(void)sendData:(NSString *)selectedDetails; //I am thinking my data is NSArray, you can use another object for store your information.

@end


@interface detailTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *details;
@property (strong, nonatomic) NSMutableArray *selectedDetails;
@property (strong, nonatomic) NSMutableArray *selectedEvents;
@property (strong, nonatomic) NSString *selectedDetailsString;



@property(nonatomic,assign)id<getDetailsDelegate> delegate;

@end

