//
//  ShareMessageViewController.m
//  Diabetik
//
//  Created by project on 1/28/16.
//  Copyright © 2016 UglyApps. All rights reserved.
//

#import "ShareMessageViewController.h"
#import "MainShareController.h"

static NSString* const kBaseURL = @"http://localhost:8080";

@interface ShareMessageViewController ()

@end

@implementation ShareMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@""
                                             style:UIBarButtonItemStylePlain
                                             target:nil
                                             action:nil];
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
    [cell setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f]];
    return cell;
}

-(IBAction)sendMessageButtonTapped:(id)sender{
    NSLog(@"send message button tapped");
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[kBaseURL stringByAppendingPathComponent:@"/message"]]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    //build an info object and convert to json
    
    NSLog(@"Entered message: %@", self.textMessageField.text);
    
    NSArray *userAccounts = [SSKeychain accountsForService:@"graduateProject"];
    NSString *loggedInUserToken = [SSKeychain passwordForService:@"graduateProject" account:[userAccounts objectAtIndex:0][kSSKeychainAccountKey]];
    
    NSDictionary *messageToShare = [NSDictionary dictionaryWithObjectsAndKeys:
                                 loggedInUserToken, @"UserToken",
                                 self.textMessageField.text, @"message",
                                 nil];
    
    //convert object to data
    NSLog(@"%@", messageToShare);
    
    if([NSJSONSerialization isValidJSONObject:messageToShare]){
        
        NSLog(@"YES, CAN CONVERT ");
        
        NSError *error;
        
        NSData* json_to_send = [NSJSONSerialization dataWithJSONObject: messageToShare options:NSJSONWritingPrettyPrinted error: &error];
        
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
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SUCCESS" message:@"Message sent!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
            else if([[jsonResponseData objectForKey:@"status"] isEqualToString:@"FAIL"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Something went wrong, Try Again!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            }
        }
        
        
    } else{
        NSLog(@"NO, CAN'T CONVERT ");
    }    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }

}
@end
