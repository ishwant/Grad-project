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
#import <CoreData/CoreData.h>

#import "FBEncryptorAES.h"


//==Trying to add sign-up
static NSString* const kBaseURL = @"http://localhost:8080";

@implementation LoginController
@synthesize  usersArray, jsonArray, userCanLogin, alertView;

-(IBAction)loginButtonTapped:(id)sender{
    
    NSLog(@"ENTERING");
    if(![userTokenField hasText] || ![userFNameField hasText] || ![userLNameField hasText]){
        alertView = [[UIAlertView alloc] initWithTitle:@"Incomplete entries" message:@"Please fill all the details" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [alertView show];
    }
    else {
        [self retrieveData];
        
        if(userCanLogin){
            [SSKeychain setPassword:[userTokenField text] forService:@"graduateProject" account:[userFNameField text]];
            
            UAAppDelegate *appDelegate = (UAAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.window setRootViewController:appDelegate.viewController];
        }
    }
  

/*     NSInteger index = 0;
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
   */
}

-(void)viewDidLoad {

    userFNameField.keyboardType = UIKeyboardTypeDefault;
    userLNameField.keyboardType = UIKeyboardTypeDefault;
    userTokenField.keyboardType = UIKeyboardTypeDefault;
    infoDictionary =[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"username", nil] forKeys:[NSArray arrayWithObjects:@"token", nil]];
}

-(void) retrieveData {
    
    NSString * enteredUserFName = userFNameField.text;
    NSString * enteredUserLName = userLNameField.text;
    NSString * enteredUserToken = userTokenField.text;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[kBaseURL stringByAppendingPathComponent:@"/appsignup"]]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    
    
    
    //ENCRYPT TOKEN
    NSString *encryptedToken= [FBEncryptorAES encryptBase64String:enteredUserToken
                                                    keyString: [enteredUserFName lowercaseString]
                                                separateLines:NO];
    NSLog(@"encrypted: %@", encryptedToken);

    
    
    //build an info object and convert to json
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          enteredUserFName, @"userFName",
                          enteredUserLName, @"userLName",
                          encryptedToken, @"userToken",
                          nil];
    
    //convert object to data
    NSLog(@"%@",info);
    
    if([NSJSONSerialization isValidJSONObject:info]){
        
        NSLog(@"YES, CAN CONVERT ");
        
        NSError *error;
        
        NSData* json_to_send = [NSJSONSerialization dataWithJSONObject: info options:NSJSONWritingPrettyPrinted error: &error];
        
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
            usersArray = [[NSMutableArray alloc] init];
            
            if([[jsonResponseData  objectForKey:@"status"]  isEqualToString: @"SUCCESS"]){
                
                NSString * ufname = userFNameField.text;
                
                NSString * ulname = userLNameField.text;
                
                NSString * utoken = userTokenField.text;
                
                //Add the user object to our users array
                [usersArray addObject:[[UserProfile alloc]initWithuserFName:ufname anduserLName:ulname anduserToken:utoken]];
                
                userCanLogin = true;
                
            }
            else if ([[jsonResponseData objectForKey:@"status"] isEqualToString:@"FAIL"] &&
                     [[jsonResponseData objectForKey:@"message"] isEqualToString:@"Token not found"]){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Token" message:@"The token is invalid, Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
            else if([[jsonResponseData objectForKey:@"status"] isEqualToString:@"FAIL"] &&
                    [[jsonResponseData objectForKey:@"message"] isEqualToString:@"User Incorrect"]){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid User" message:@"The user name is invalid, Try Again!" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        
    } else{
        NSLog(@"NO, CAN'T CONVERT ");
    }
    
    
    
    
    
/*  GET API SAMPLE
 
 NSString * enteredUser = userFNameField.text;
     
     //   NSURL* url = [NSURL URLWithString:kBaseURL];
     NSURL* url = [NSURL URLWithString:[kBaseURL stringByAppendingPathComponent:enteredUser]];
     
    
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
     
*/
    
//==========Testing signup
    
   // SAMPLE
    //  NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    //   request.HTTPMethod = @"GET"; //2
    // [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //   [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //   NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration]; //4
    //   NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    

    /* POST API IMPLEMENTATION
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]
                                    initWithURL:[NSURL
                                                 URLWithString:[kBaseURL stringByAppendingPathComponent:@"/signup"]]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json"
   forHTTPHeaderField:@"Content-type"];
    
    NSString * enteredUser = userFNameField.text;
    NSString * enteredPassword = userLNameField.text;
    //build an info object and convert to json
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          enteredUser, @"username",
                          enteredPassword, @"password",
                          nil];
    
    //convert object to data
    
    if([NSJSONSerialization isValidJSONObject:info]){
        NSLog(@"YES, CAN CONVERT ");
    } else{
        NSLog(@"NO, CAN'T CONVERT ");
    }
    NSError *error;
    NSData* json_to_send = [NSJSONSerialization dataWithJSONObject: info options:NSJSONWritingPrettyPrinted error: &error];

    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[json_to_send length]] forHTTPHeaderField:@"Content-length"];
    request.HTTPBody = json_to_send;
    
    //send request
    
    //WORKING [[NSURLConnection alloc] initWithRequest:request delegate:self];

    //TESTING REQUEST
    
    NSError *requestError = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&response
                                                        error:&requestError];

    NSDictionary *jsonDataTest = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:nil];
    NSLog(@"%@",jsonDataTest);

    NSString *output_result = [jsonDataTest objectForKey:@"result"];
    
    if(![output_result isEqual:nil]){
        
        if([output_result  isEqual: @"success"]){
            
            NSString * uName = userNameField.text;
            NSLog(@"%@",uName);
            NSString * uPass = passwordField.text;
            NSLog(@"%@",uPass);
            //Add the user object to our users array
            [usersArray addObject:[[UserProfile alloc]initWithUserName:uName anduserPassword: uPass]];
            
        }
    }
    
    */
}


@end
