//
//  NSObject+UA.m
//  Diabetik
//
//  Created by project on 11/23/15.
//  Copyright © 2015 UglyApps. All rights reserved.
//

#import "UAJournalViewController.h"
#import "UASideMenuViewController.h"
#import "LoginController.h"
#import "UserProfile.h"
#import "UAAppDelegate.h"

static NSString* const kBaseURL = @"http://localhost:3000/userdb";

@implementation LoginController
@synthesize  usersArray, jsonArray, userCanLogin;

-(IBAction)loginButtonTapped:(id)sender{
    
    [self retrieveData];
    
    NSInteger index = 0;
    UserProfile *loginuser = [usersArray objectAtIndex:index];
    
    
    if(usersArray.count == 1){
      //  NSLog(@"Username exists!!");
        
        if ([passwordField.text isEqualToString:loginuser.userPassword]) {
            NSLog(@"if statement is TRUE");
            
            
            userCanLogin = true;
            
         //   [UAAppDelegate: keychain setObject:[userNameField text] forKey:(id)kSecAttrAccount];
         //   [keychain setObject:[passwordField text] forKey:(id)kSecValueData];
            [SSKeychain setPassword:[passwordField text]
                         forService:@"graduateProject"
                            account:[userNameField text]];
            
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"Correct Password" message:@"The password is correct" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [alert1 show];
            
            //change to tabviewcontroller
            
            UAAppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
            [appDelegate.window setRootViewController:appDelegate.viewController];
            
        } else {
            NSLog(@"if statement is FALSE");
            UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials" message:@"Incorrect Username/Password, Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [alert2 show];
        }
    } else {
        //No such user exists
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:@"Incorrect Username/Password" message:@"The password is Incorrect" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alert2 show];
    }
}

-(void)viewDidLoad {

    userNameField.keyboardType = UIKeyboardTypeDefault;
    passwordField.keyboardType = UIKeyboardTypeDefault;
    infoDictionary =[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"username", nil] forKeys:[NSArray arrayWithObjects:@"password", nil]];
}

-(void) retrieveData {
    
    NSString * enteredUser = userNameField.text;
    
 //   NSURL* url = [NSURL URLWithString:kBaseURL];
    NSURL* url = [NSURL URLWithString:[kBaseURL stringByAppendingPathComponent:enteredUser]];
    
    //  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    //   request.HTTPMethod = @"GET"; //2
    // [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //   [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //   NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //4
    //   NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:NULL]; //6
    NSLog(@"%@",url);
    //  NSLog(@"%@",request);
    
    //    jsonArray = [NSJSONSerialization JSONObjectWithData:data options:
    //                kNilOptions error:nil];
    
    
    usersArray = [[NSMutableArray alloc] init];
    
    NSInteger count = jsonArray.count;
    NSLog(@"The value of COUNT is %li",(long)count);

        NSString * uID = [[jsonArray objectAtIndex:0] objectForKey:@"_id"];
        NSLog(@"%@",uID);
        NSString * uName = [[jsonArray objectAtIndex:0] objectForKey:@"user"];
        NSLog(@"%@",uName);
        NSString * uPass = [[jsonArray objectAtIndex:0] objectForKey:@"password"];

        //Add the user object to our users array
        [usersArray addObject:[[UserProfile alloc]initWithUserName:uName anduserPassword: uPass anduserID: uID]];
        

}


@end
