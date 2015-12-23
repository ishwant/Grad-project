//
//  LoginController.h
//  Diabetik
//
//  Created by project on 11/23/15.
//  Copyright © 2015 UglyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSKeychain.h"


@interface LoginController: UIViewController {
    IBOutlet UITextField *userNameField;
    IBOutlet UITextField *passwordField;
    NSDictionary *infoDictionary;
//@public    KeychainItemWrapper *keychain;
}

//@property (strong, nonatomic) UIViewController *viewController;
//@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *jsonArray;
@property (nonatomic, assign) BOOL *userCanLogin;

#pragma  mark -
#pragma  mark Class Methods

-(void) retrieveData;
-(IBAction)loginButtonTapped:(id)sender;

@end

