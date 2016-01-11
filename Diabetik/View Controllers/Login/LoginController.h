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
    IBOutlet UITextField *userFNameField;
    IBOutlet UITextField *userLNameField;
    IBOutlet UITextField *userTokenField;
    NSDictionary *infoDictionary;
}

//@property (strong, nonatomic) UIViewController *viewController;
//@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *jsonArray;
@property (nonatomic, assign) BOOL *userCanLogin;
@property (nonatomic,retain) UIAlertView *alertView;

#pragma  mark -
#pragma  mark Class Methods

-(void) retrieveData;
-(IBAction)loginButtonTapped:(id)sender;

@end

