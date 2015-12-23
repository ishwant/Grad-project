//
//  UserProfile.h
//  Diabetik
//
//  Created by project on 11/28/15.
//  Copyright © 2015 UglyApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userPassword;

#pragma mark -
#pragma mark Class Methods

-(id)initWithUserName : (NSString *)uName anduserPassword: (NSString *)uPass anduserID : (NSString *)uID;

@end
