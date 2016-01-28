//
//  ShareMessageViewController.m
//  Diabetik
//
//  Created by project on 1/28/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "ShareMessageViewController.h"

@interface ShareMessageViewController ()

@end

@implementation ShareMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"ShareMessageViewController loading");
    self.title = @"Send Message";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
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
        
        self.textMessageField = [[UITextField alloc] initWithFrame:CGRectMake(65, 20, 200, 30)];
        self.textMessageField.placeholder = @"Type message here.... ";
        self.textMessageField.autocorrectionType = UITextAutocorrectionTypeNo;
        [self.textMessageField setBorderStyle:UITextBorderStyleRoundedRect];
        [self.textMessageField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [cell addSubview:self.textMessageField];
    }
    if (indexPath.row == 1){
        
        self.sendMessageButton = [[UIButton alloc] initWithFrame:CGRectMake(65,20,200,30)];
        [self.sendMessageButton setBackgroundColor:[UIColor grayColor]];
        [self.sendMessageButton addTarget:self action:@selector(sendMessageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.sendMessageButton setTitle:@"Send Message" forState:UIControlStateNormal];
        
        [cell addSubview:self.sendMessageButton];
    }
    return cell;
}

-(IBAction)sendMessageButtonTapped:(id)sender{
    NSLog(@"send message button tapped");
}

@end
