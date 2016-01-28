//
//  MainShareController.m
//  Diabetik
//
//  Created by project on 1/28/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "MainShareController.h"
#import "SelectPostViewController.h"
#import "ShareMessageViewController.h"

@interface MainShareController ()

@end

@implementation MainShareController

@synthesize tableView = _tableView;
@synthesize postButton, messageButton, alertView;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MainShareController loading");
    self.title = @"SHARE";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
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
        
        self.postButton = [[UIButton alloc] initWithFrame:CGRectMake(65,20,200,30)];
        [self.postButton setBackgroundColor:[UIColor grayColor]];
        [self.postButton addTarget:self action:@selector(postButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.postButton setTitle:@"Send Entries" forState:UIControlStateNormal];
        
        [cell addSubview:self.postButton];
    }
    if (indexPath.row == 1){
        
        self.messageButton = [[UIButton alloc] initWithFrame:CGRectMake(65,20,200,30)];
        [self.messageButton setBackgroundColor:[UIColor grayColor]];
        [self.messageButton addTarget:self action:@selector(messageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.messageButton setTitle:@"Send Message" forState:UIControlStateNormal];
        
        [cell addSubview:self.messageButton];
    }
    return cell;
}
-(IBAction)postButtonTapped:(id)sender{
    NSLog(@"Send Entries Button");
    SelectPostViewController *vc = [[SelectPostViewController alloc] init];
    [[self navigationController] pushViewController:vc animated:YES];

}
-(IBAction)messageButtonTapped:(id)sender{
    NSLog(@"Send Message Button");
    ShareMessageViewController *vc = [[ShareMessageViewController alloc] init];
    [[self navigationController] pushViewController:vc animated:YES];
}


@end
